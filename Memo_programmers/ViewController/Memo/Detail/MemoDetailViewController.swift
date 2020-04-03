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
import Photos

/**
 ImageURLInputViewController 에서 로드한 UIImage 가져오기
 */
protocol MemoDetailLoadURLImageDelegate: class {
  func addLoadURLImage(image: UIImage)
}

class MemoDetailViewController: UIViewController {
  
  static let photoIdentifier = "DetailsCollectionViewCell"
  
  // MARK: - Properties
  
  private typealias UI = Constant.UI
  private var viewBottomConstrant: NSLayoutConstraint?
  private var textViewHeight: NSLayoutConstraint?
  private var lastScrollOffset: CGFloat?
  private var memoTextViewHeight: CGFloat = 0
  private var viewModel: MemoViewModelType
  private var isKeyboardShow: Bool = false
  
  private var disposeBag = DisposeBag()
  private var currentDetailType: MemoDetailType? {
    didSet {
      if currentDetailType != nil {
        configure(type: currentDetailType!)
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
  
  // MARK: - Init
  
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
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
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
  
  // MARK: - View ✨
  
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
  // MARK: - Bind 🏷
  
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
      .withLatestFrom(self.viewModel.outputs.memo)
      .subscribe(onNext: { [weak self] (memo) in
        self?.openMemoEditVC(memo: memo)
      }).disposed(by: disposeBag)
    
    memoDetailView.titleTextView.textField.rx.text
      .orEmpty
      .bind(to: (self.viewModel.inputs.title))
      .disposed(by: disposeBag)
    
    memoDetailView.memoTextView.textView.rx.text
      .orEmpty
      .bind(to: (self.viewModel.inputs.content))
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
  
  lazy var memoDetailView: MemoDetailView = {
    let view = MemoDetailView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  // MARK: - Functions
  
  /**
   현재 Detail View 의 타입에 따른 View Setting
   */
  func configure(type: MemoDetailType){
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
  
  func memoTextViewDidBegin() {
    self.lastScrollOffset = self.memoDetailView.scrollView.contentOffset.y
    DispatchQueue.main.async {
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
  
  func checkCameraAuthorize() {
    typealias PopupConstant = Constant.Authorize.Camera
    
    let cameraMediaType = AVMediaType.video
    let status = AVCaptureDevice.authorizationStatus(for: cameraMediaType)
    
    switch status {
    case .notDetermined:
      AVCaptureDevice.requestAccess(for: .video) { (_) in
        self.checkCameraAuthorize()
      }
    case .restricted, .denied:
      let data = PopupData(body: PopupConstant.data.body,
                           left: PopupConstant.data.left,
                           right: PopupConstant.data.right,
                           rightHandler: { () in
                            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                              return
                            }
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                              UIApplication.shared.open(settingsUrl, completionHandler: { _ in self.checkCameraAuthorize()})
                            }
      })
      DispatchQueue.main.async {
        self.present(PopupViewController(data: data), animated: true)
      }
    case .authorized:
      self.openCamera()
    @unknown default:
      break
    }
  }
  
  func checkPhotoAuthorize() {
    typealias PopupConstant = Constant.Authorize.Photo
    
    let status = PHPhotoLibrary.authorizationStatus()
    switch status {
    case .authorized:
      self.openPhotoPicker()
    case .denied, .restricted :
      let data = PopupData(body: PopupConstant.data.body,
                           left: PopupConstant.data.left,
                           right: PopupConstant.data.right,
                           rightHandler: { () in
                            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                              return
                            }
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                              UIApplication.shared.open(settingsUrl, completionHandler: { _ in self.checkPhotoAuthorize()})
                            }
      })
      DispatchQueue.main.async {
        self.present(PopupViewController(data: data), animated: true)
      }
    case .notDetermined:
      PHPhotoLibrary.requestAuthorization { (_) in
        self.checkPhotoAuthorize()
      }
    @unknown default:
      break
    }
  }
  
  // MARK: - Popup
  
  func shareMemo(text: String) {
    let textToShare = text
    let objectsToShare = [textToShare] as [Any]
    let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
    activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
    present(activityVC, animated: true, completion: nil)
  }
  
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
      self.checkCameraAuthorize()
    }))
    vc.addAction(BottomCellData(cellData: memoAddImage.loadByGallery, handler: {
      self.checkPhotoAuthorize()
    }))
    vc.addAction(BottomCellData(cellData: memoAddImage.loadByURL, handler: {
      let vc = ImageURLInputPopupViewController()
      vc.delegate = self
      self.present(vc, animated: true, completion: nil)
    }))
    self.present(vc, animated: true, completion: nil)
  }
  
  // MARK: - Open Gallery & Camera
  
  func openPhotoPicker() {
    DispatchQueue.main.async {
      let picker: UIImagePickerController = UIImagePickerController()
      picker.delegate = self
      picker.allowsEditing = false
      picker.sourceType = .photoLibrary
      self.present(picker, animated: true, completion: nil)
    }
  }
  
  func openCamera() {
    DispatchQueue.main.async {
      let picker: UIImagePickerController = UIImagePickerController()
      picker.delegate = self
      picker.allowsEditing = false
      picker.sourceType = .camera
      self.present(picker, animated: true, completion: nil)
    }
  }
  
  func openImages(index: Int) {
    let vc = ImageViewController(images: self.viewModel.inputs.imageArray.value.map {
      return $0.image
    }, selectedIndex: index)
    vc.modalPresentationStyle = .overFullScreen
    vc.modalTransitionStyle = .coverVertical
    self.present(vc, animated: true, completion: nil)
  }
  
  // MARK: - Keyboard
  
  @objc func keyboardWillShow(_ notification: Notification) {
    guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
    let keyboardHeight = keyboardFrame.height
    self.memoTextViewHeight = (view.frame.height - memoDetailView.memoTextView.frame.minY - keyboardHeight - 46 - UI.safeInsetBottom_iOS10)
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
  
  @objc func deleteImage(_ button: UIButton) {
    var images = self.viewModel.inputs.imageArray.value
    images.remove(at: button.tag)
    self.viewModel.inputs.imageArray.accept(images)
    self.memoDetailView.photoCollect.performBatchUpdates({
      self.memoDetailView.photoCollect.deleteItems(at: [IndexPath(row: button.tag, section: 0)])
    }) { (finished) in
      self.memoDetailView.photoCollect.reloadItems(at: self.memoDetailView.photoCollect.indexPathsForVisibleItems)
    }
  }
  
  @objc func donePressed(){
    view.endEditing(true)
  }
  
  @objc func cancelPressed(){
    view.endEditing(true)
  }
}

// MARK: - MemoDetailLoadURLImageDelegate

extension MemoDetailViewController: MemoDetailLoadURLImageDelegate {
  func addLoadURLImage(image: UIImage) {
    self.viewModel.inputs.imageArray.accept((self.viewModel.inputs.imageArray.value ) + [Image(image: image, date: Date())])
    memoDetailView.photoCollect.reloadData()
  }
}

// MARK: - UITextViewDelegate

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
      textView.inputAccessoryView = toolBar
    }
  }
  
}

// MARK: - UICollectionViewDelegate

extension MemoDetailViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if currentDetailType == MemoDetailType.Add ||
      currentDetailType == MemoDetailType.Edit {
      if indexPath.row == self.viewModel.inputs.imageArray.value.count {
        self.openPhotoVC()
      } else {
        self.openImages(index: indexPath.row)
      }
    } else {
      if self.viewModel.inputs.imageArray.value.count != 0 {
        self.openImages(index: indexPath.row)
      }
    }
  }
}

// MARK: - UICollectionViewDataSource

extension MemoDetailViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if currentDetailType == MemoDetailType.Add ||
      currentDetailType == MemoDetailType.Edit {
      return (self.viewModel.inputs.imageArray.value.count) + 1
    } else if self.viewModel.inputs.imageArray.value.count == 0 {
      return 1
    } else {
      return (self.viewModel.inputs.imageArray.value.count )
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MemoDetailViewController.photoIdentifier, for: indexPath) as! MemoPhotoAddPhotoCell
    cell.deleteButton.tag = indexPath.row
    cell.deleteButton.addTarget(self, action: #selector(deleteImage(_:)), for: .touchUpInside)
    if indexPath.row == self.viewModel.inputs.imageArray.value.count {
      cell.configure(image: nil, type: self.currentDetailType ?? MemoDetailType.Add, count: self.viewModel.inputs.imageArray.value.count )
    } else {
      cell.configure(image: self.viewModel.inputs.imageArray.value[indexPath.row].image, type: self.currentDetailType ?? MemoDetailType.Add, count: viewModel.inputs.imageArray.value.count)
    }
    return cell
  }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate

extension MemoDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage, let imageOrientaion = chosenImage.fixedOrientation() {
      self.viewModel.inputs.imageArray
        .accept((self.viewModel.inputs.imageArray.value ) + [Image(image: imageOrientaion, date: Date())])
      
      memoDetailView.photoCollect.reloadData()
    }
    picker.dismiss(animated: true, completion: nil)
  }
}


