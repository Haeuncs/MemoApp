//
//  MemoDetailViewController.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/11.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

/**
 현재 메모뷰의 Type
 - Edit: 기존 메모 편집
 - Add: 메모 추가
 - Read: 기존 메모 열람
 */
enum MemoDetailType {
  case Edit
  case Add
  case Read
}
/**
 현재 메모 뷰에서 나타나는 팝업 이벤트 Type
 */
enum MemoDetailPopupType {
  case edit
  case delete
  case loadPhoto
  case camera
  case urlLoadImage
}
/**
 MemoDetailPopupType 에 따른 팝업 띄우기
 */
protocol MemoDetailDelegate: class {
  func memoDetailPopup(type: MemoDetailPopupType)
}
/**
 ImageURLInputViewController 에서 로드한 UIImage 가져오기
 */
protocol MemoDetailLoadURLImageDelegate: class {
  func addLoadURLImage(image: UIImage)
}

protocol MemoDetailDeleteImageDelegate: class {
  func deleteImage(index: Int)
}

class MemoDetailViewController: UIViewController {
  static let photoIdentifier = "DetailsCollectionViewCell"
  
  private typealias UI = Constant.UI
  
  private var disposeBag = DisposeBag()
  private var currentDetailType: MemoDetailType? {
    didSet {
      if currentDetailType != nil {
        setDetailType(type: currentDetailType!)
        if currentDetailType != MemoDetailType.Read {
          self.addToolBar(textView: memoDetailView.memoTextView.textView)
        }
        if currentDetailType == MemoDetailType.Edit {
          self.memoDetailView.navView.titleLabel.text = "편집"
        } else {
          self.memoDetailView.navView.titleLabel.text = ""
        }
      }
      memoDetailView.photoCollect.reloadData()
    }
  }
  private var viewBottomConstrant: NSLayoutConstraint?
  private var textViewHeight: NSLayoutConstraint?
  private var lastScrollOffset: CGFloat?
  private var memoTextViewHeight: CGFloat = 0
  private var viewModel: MemoViewModel
  private var isKeyboardShow: Bool = false
  
  lazy var memoDetailView: MemoDetailView = {
    let view = MemoDetailView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  init(type: MemoDetailType, coreData: CoreDataModelType, memoData: MemoData?) {
    self.viewModel = MemoViewModel(coreData: coreData, memo: memoData)
    super.init(nibName: nil, bundle: nil)
    defer {
      if let memo = memoData {
        memoDetailView.titleTextView.textField.text = memoData?.title
        memoDetailView.memoTextView.textView.text = memoData?.memo
        memoDetailView.configureDate(createDate: memo.date, editDate: memo.modifyDate)
      }
      self.currentDetailType = type
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // MARK: keyboard
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
    
    initView()
    bindRx()
    
    self.setupHideKeyboardOnTap()
    setAppearance()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    memoDetailView.memoTextView.textView.isScrollEnabled = true
    textViewHeight = memoDetailView.memoTextView.textView.heightAnchor.constraint(equalToConstant: memoDetailView.memoTextView.textView.contentSize.height)
    textViewHeight?.isActive = true
  }
  func setAppearance(){
    view.backgroundColor = Color.background
    memoDetailView.setAppearance()
  }
  // View ✨
  func initView(){
    self.view.addSubview(memoDetailView)
    memoDetailView.scrollView.delegate = self
    memoDetailView.photoCollect.delegate = self
    memoDetailView.photoCollect.dataSource = self
    memoDetailView.snp.makeConstraints { (make) in
      if #available(iOS 11.0, *) {
        make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
      } else {
        // Fallback on earlier versions
        make.top.leading.trailing.equalTo(view)
      }
    }
    viewBottomConstrant = self.memoDetailView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    viewBottomConstrant?.isActive = true
    
  }
  // Bind 🏷
  func bindRx(){
    self.viewModel.outputs.error
      .subscribe(onNext: { (string) in
        ToastMessage.show(message: string)
      }).disposed(by: disposeBag)
    
    memoDetailView.navView.popButton.rx.tap
      .subscribe(onNext: { [weak self] (_) in
        self?.navigationController?.popViewController(animated: true)
      }).disposed(by: disposeBag)
    
    memoDetailView.navView.titleButton.rx.tap
      .subscribe(onNext: { [weak self] (_) in
        if (self?.currentDetailType == MemoDetailType.Add) {
          let bool = self?.viewModel.inputs.add()
          if bool ?? false {
            self?.navigationController?.popViewController(animated: true)
          }
        }else if (self?.currentDetailType == MemoDetailType.Edit) {
          let bool = self?.viewModel.inputs.update()
          if bool ?? false {
            self?.navigationController?.popViewController(animated: true)
          }
        }
      }).disposed(by: disposeBag)
    
    memoDetailView.navView.dotButton.rx.tap
      .subscribe(onNext: { [weak self](_) in
        self?.openMemoEditVC(memo: (self?.viewModel.memo)!)
      }).disposed(by: disposeBag)
    
    memoDetailView.titleTextView.textField.rx.text
      .orEmpty
      .bind(to: (self.viewModel.title))
      .disposed(by: disposeBag)
    
    
    memoDetailView.memoTextView.textView.rx.text
      .orEmpty
      .bind(to: (self.viewModel.content))
      .disposed(by: disposeBag)
    
    memoDetailView.memoTextView.textView.rx
      .didBeginEditing
      .subscribe(onNext: { [weak self] (_) in
        self?.memoTextViewDidBegin()
      }).disposed(by: disposeBag)
    
    memoDetailView.memoTextView.textView.rx
      .didEndEditing
      .subscribe(onNext: { [weak self] (_) in
        self?.isKeyboardShow = false
        self?.memoTextViewDidEnd()
      }).disposed(by: disposeBag)
    
  }
  /**
   현재 Detail View 의 타입에 따른 View Setting
   */
  func setDetailType(type: MemoDetailType){
    memoDetailView.navView.configure(type: type)
    switch type {
    case .Edit, .Add:
      memoDetailView.titleTextView.textField.isEnabled = true
      memoDetailView.memoTextView.textView.isEditable = true
    case .Read:
      memoDetailView.titleTextView.textField.isEnabled = false
      memoDetailView.memoTextView.textView.isEditable = false
    }
  }
  // MARK: - MEMO TEXT VIEW EVENT
  func memoTextViewDidBegin() {
    self.lastScrollOffset = self.memoDetailView.scrollView.contentOffset.y
    DispatchQueue.main.async {
      //      self.memoDetailView.scrollView.setContentOffset(CGPoint(x: 0, y:  self.memoDetailView.memoTextView.frame.minY - 32), animated: true)
      self.textViewHeight?.constant = self.memoTextViewHeight
      UIView.animate(withDuration: UI.animationDuration, animations: {
        self.view.layoutIfNeeded()
      }) { (_) in
        UIView.animate(withDuration: UI.animationDuration) {
          self.memoDetailView.scrollView.contentOffset.y = self.memoDetailView.memoTextView.frame.minY - 32
        }
        self.isKeyboardShow = true
      }
    }
  }
  func memoTextViewDidEnd() {
    DispatchQueue.main.async {
      self.textViewHeight?.constant = self.memoDetailView.memoTextView.textView.contentSize.height
      UIView.animate(withDuration: UI.animationDuration, animations: {
        self.view.layoutIfNeeded()
      }) { (_) in
      }
    }
  }
  /// 선택된 메모 공유
  func shareMemo(text: String) {
    let textToShare = text
    let objectsToShare = [textToShare] as [Any]
    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
    activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
    
    present(activityVC, animated: true, completion: nil)
  }
  /// 선택된 메모 수정
  func openMemoEditVC(memo: MemoData) {
    let memoEditType = Constant.BottomPopup.MemoEditType.self
    let vc = BottomViewController(title: memoEditType.typeTitle)
    vc.addAction(BottomCellData(cellData: memoEditType.share, handler: {
      self.shareMemo(text: memo.memo ?? "")
    }))
    vc.addAction(BottomCellData(cellData: memoEditType.edit, handler: {
      self.currentDetailType = .Edit
    }))
    vc.addAction(BottomCellData(cellData: memoEditType.delete, handler: {
      let (bool) = self.viewModel.inputs.delete()
      if (bool) {
        self.navigationController?.popViewController(animated: true)
      }
    }))
    present(vc, animated: true, completion: nil)
  }
  
  func openPhotoVC() {
    let memoAddImage = Constant.BottomPopup.MemoAddPhotoType.self
    let vc = BottomViewController(title: memoAddImage.typeTitle)
    vc.addAction(BottomCellData(cellData: memoAddImage.loadByCamera, handler: {
      self.openCamera()
    }))
    vc.addAction(BottomCellData(cellData: memoAddImage.loadByGallery, handler: {
      self.openPhotoPicker()
    }))
    vc.addAction(BottomCellData(cellData: memoAddImage.loadByURL, handler: {
      let vc = ImageURLInputPopupViewController()
      vc.delegate = self
      self.present(vc, animated: true, completion: nil)
    }))
    self.present(vc, animated: true, completion: nil)
  }
  // MARK: - Open Gallery & Camera
  func openPhotoPicker(){
    let picker: UIImagePickerController = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = false
    picker.sourceType = .photoLibrary
    DispatchQueue.main.async {
      weak var pvc = self.presentedViewController
      pvc?.dismiss(animated: true) {
        self.present(picker, animated: true, completion: nil)
      }
    }
  }
  func openCamera(){
    let picker: UIImagePickerController = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = false
    picker.sourceType = .camera
    DispatchQueue.main.async {
      weak var pvc = self.presentedViewController
      pvc?.dismiss(animated: true) {
        self.present(picker, animated: true, completion: nil)
      }
    }
  }
  func openImages(index: Int) {
    let vc = ImageViewController(images: self.viewModel.imageArray.value.map {
      return $0.image
    }, selectedIndex: index)
    vc.modalPresentationStyle = .overFullScreen
    vc.modalTransitionStyle = .coverVertical
    self.present(vc, animated: true, completion: nil)
  }
  
  // MARK: - KeyboardWillShow
  @objc func keyboardWillShow(_ notification: Notification){
    guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
    let keyboardHeight = keyboardFrame.height
    print(keyboardHeight)
    if #available(iOS 11.0, *) {
      self.memoTextViewHeight = (view.frame.height - memoDetailView.memoTextView.frame.minY - keyboardHeight - 46 - UI.safeInsetBottom)
    } else {
      // Fallback on earlier versions
      self.memoTextViewHeight = (view.frame.height - memoDetailView.memoTextView.frame.minY - keyboardHeight - 46 - UI.safeInsetBottom_iOS10)
    }
    viewBottomConstrant?.constant = -keyboardFrame.height
    UIView.animate(withDuration: Constant.UI.animationDuration) {
      self.view.layoutIfNeeded()
    }
  }
  @objc func keyboardWillHide(){
    viewBottomConstrant?.constant = 0
    self.isKeyboardShow = false
    UIView.animate(withDuration: Constant.UI.animationDuration) {
      self.view.layoutIfNeeded()
    }
  }
  /// 선택된 이미지를 삭제
  @objc func deleteImage(_ button: UIButton) {
    var images = self.viewModel.imageArray.value
    images.remove(at: button.tag)
    self.viewModel.imageArray.accept(images)
    self.memoDetailView.photoCollect.performBatchUpdates({
      self.memoDetailView.photoCollect.deleteItems(at: [IndexPath(row: button.tag, section: 0)])
    }) { (finished) in
      self.memoDetailView.photoCollect.reloadItems(at: self.memoDetailView.photoCollect.indexPathsForVisibleItems)
    }
  }
  
  //  func scrollViewDidScroll(_ scrollView: UIScrollView) {
  //    if isKeyboardShow {
  //      view.endEditing(true)
  //    }
  //  }
  
}

extension MemoDetailViewController: UITextViewDelegate {
  func addToolBar(textView: UITextView){
    if self.currentDetailType != MemoDetailType.Read {
      let toolBar = UIToolbar()
      toolBar.barStyle = UIBarStyle.default
      toolBar.isTranslucent = true
      toolBar.tintColor = Color.black
      let doneButton = UIBarButtonItem(title: "완료", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePressed))
      let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      toolBar.setItems([spaceButton, doneButton], animated: false)
      toolBar.isUserInteractionEnabled = true
      toolBar.sizeToFit()
      
      //      textView.delegate = self
      textView.inputAccessoryView = toolBar
    }
  }
  @objc func donePressed(){
    view.endEditing(true)
  }
  @objc func cancelPressed(){
    view.endEditing(true) // or do something
  }
}

extension MemoDetailViewController: MemoDetailDelegate {
  func memoDetailPopup(type: MemoDetailPopupType) {
    switch type {
    case .delete:
      let (bool) = self.viewModel.inputs.delete()
      if (bool) {
        // 현재 표시되고 있는 뷰 (bottom popup vc)
        weak var pvc = self.presentedViewController
        pvc?.dismiss(animated: true) {
          self.navigationController?.popViewController(animated: true)
        }
      }
    case .edit:
      weak var pvc = self.presentedViewController
      pvc?.dismiss(animated: true, completion: {
        self.currentDetailType = .Edit
      })
    case .camera:
      self.openCamera()
    case .urlLoadImage:
      weak var pvc = self.presentedViewController
      pvc?.dismiss(animated: true, completion: {
        let vc = ImageURLInputPopupViewController()
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
      })
    case .loadPhoto:
      self.openPhotoPicker()
    }
  }
}


extension MemoDetailViewController: MemoDetailLoadURLImageDelegate {
  func addLoadURLImage(image: UIImage) {
    self.viewModel.imageArray.accept((self.viewModel.imageArray.value ) + [Image(image: image, date: Date())])
    memoDetailView.photoCollect.reloadData()
  }
}


extension MemoDetailViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if currentDetailType == MemoDetailType.Add ||
      currentDetailType == MemoDetailType.Edit {
      if indexPath.row == self.viewModel.imageArray.value.count {
        self.openPhotoVC()
      } else {
        self.openImages(index: indexPath.row)
      }
    } else {
      if self.viewModel.imageArray.value.count != 0 {
        self.openImages(index: indexPath.row)
      }
    }
  }
}

extension MemoDetailViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if currentDetailType == MemoDetailType.Add ||
      currentDetailType == MemoDetailType.Edit {
      return (self.viewModel.imageArray.value.count ) + 1
    } else if self.viewModel.imageArray.value.count == 0 {
      return 1
    } else {
      return (self.viewModel.imageArray.value.count )
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoDetailViewController.photoIdentifier, for: indexPath) as! MemoPhotoAddPhotoCell
    cell.deleteButton.tag = indexPath.row
    cell.deleteButton.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)
    if indexPath.row == self.viewModel.imageArray.value.count {
      cell.configure(image: nil, type: self.currentDetailType ?? MemoDetailType.Add, count: self.viewModel.imageArray.value.count )
    } else {
      cell.configure(image: self.viewModel.imageArray.value[indexPath.row].image, type: self.currentDetailType ?? MemoDetailType.Add, count: self.viewModel.imageArray.value.count)
    }
    return cell
  }
}

extension MemoDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  //MARK: UIImagePickerControllerDelegate
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let imageOrientaion = chosenImage.fixedOrientation() {
      self.viewModel
        .imageArray
        .accept((self.viewModel.imageArray.value ) + [Image(image: imageOrientaion, date: Date())])
      
      memoDetailView.photoCollect.reloadData()
    }
    picker.dismiss(animated: true, completion: nil)
  }
}


