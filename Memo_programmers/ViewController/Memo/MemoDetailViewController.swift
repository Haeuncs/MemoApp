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

protocol MemoDetailLoadURLImageDelegate: class {
  func addLoadURLImage(image: UIImage)
}
class MemoDetailViewController: BaseViewController {
  private var disposeBag = DisposeBag()
  private var currentDetailType: MemoDetailType? {
    didSet {
      if currentDetailType != nil {
        setDetailType(type: currentDetailType!)
      }
      self.photoCollect.reloadData()
    }
  }
  private var textViewHeight: NSLayoutConstraint?
  private var lastScrollOffset: CGFloat?
  private var height: CGFloat = 0
  private var viewModel: MemoViewModelType?
  private var memoData: MemoData = MemoData(){
    didSet {
      self.titleTextView.textField.text = self.memoData.title
      self.memoTextView.textView.text = self.memoData.memo
    }
  }
  init(type: MemoDetailType, coreData: CoreDataModelType, memoData: MemoData?) {
    self.viewModel = MemoViewModel(coreData: coreData)
    super.init(nibName: nil, bundle: nil)
    defer {
//      self.setDetailType(type: type)
      if memoData != nil {
      self.memoData = memoData!
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
    
    bindRx()
    contentView.addSubview(navView)
    contentView.addSubview(scrollView)
    scrollView.addSubview(titleTextView)
    scrollView.addSubview(memoTextView)
    scrollView.addSubview(photoLabel)
    scrollView.addSubview(photoCollect)
    
    navView.snp.makeConstraints { (make) in
      make.top.leading.trailing.equalTo(contentView)
      make.height.equalTo(34+16)
    }
    scrollView.snp.makeConstraints { (make) in
      make.top.equalTo(navView.snp.bottom)
      make.leading.trailing.bottom.equalTo(view)
      //      make.height.equalTo(1000)
    }
    titleTextView.snp.makeConstraints { (make) in
      make.top.equalTo(scrollView.snp.top).offset(24)
      make.leading.trailing.equalTo(contentView)
    }
    memoTextView.snp.makeConstraints { (make) in
      make.top.equalTo(titleTextView.snp.bottom).offset(30)
      make.leading.trailing.equalTo(contentView)
    }
    photoLabel.snp.makeConstraints { (make) in
      make.top.equalTo(memoTextView.snp.bottom).offset(30)
      make.leading.trailing.equalTo(contentView)
    }
    photoCollect.snp.makeConstraints { (make) in
      make.top.equalTo(photoLabel.snp.bottom)
      make.leading.trailing.equalTo(view)
      make.height.equalTo(132)
      make.bottom.equalTo(scrollView.snp.bottom)
    }
    
    navView.dotButton.rx.tap
      .subscribe(onNext: { [weak self](_) in
        let vc = MemoBottomPopupViewController(data: (self?.viewModel?.outputs.memoEditData)!)
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self?.present(vc, animated: true, completion: nil)
      }).disposed(by: disposeBag)
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    print(self.memoTextView.textView.contentSize.height)
//    self.photoCollect.reloadData()

  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    memoTextView.textView.isScrollEnabled = true
    textViewHeight = memoTextView.textView.heightAnchor.constraint(equalToConstant: memoTextView.textView.contentSize.height)
    textViewHeight?.isActive = true
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  func setDetailType(type: MemoDetailType){
    self.navView.configure(type: type)
    switch type {
    case .Edit:
      self.titleTextView.textField.isEnabled = true
      self.memoTextView.textView.isEditable = true
    // 콜렉션뷰도 셋팅 필요
    case .Add:
      self.titleTextView.textField.isEnabled = true
      self.memoTextView.textView.isEditable = true
    case .Read:
      self.titleTextView.textField.isEnabled = false
      self.memoTextView.textView.isEditable = false
    }
  }
  func bindRx(){
    navView.popButton.rx.tap
      .subscribe(onNext: { [weak self] (_) in
        self?.navigationController?.popViewController(animated: true)
      }).disposed(by: disposeBag)
    navView.titleButton.rx.tap
      .subscribe(onNext: { [weak self] (_) in
        if (self?.currentDetailType == MemoDetailType.Add) {
          let (bool, error) = self?.viewModel?.inputs.add(
            newMemo: MemoData(title: self?.titleTextView.textField.text,
                              memo: self?.memoTextView.textView.text,
                              date: Date(),
                              identifier: UUID(),
                              imageArray: self?.memoData.imageArray)) ?? (false, nil)
          
          if bool {
            self?.navigationController?.popViewController(animated: true)
          }else {
            debugPrint(error!)
          }
        }else if (self?.currentDetailType == MemoDetailType.Edit) {
          let (bool, error) = self?.viewModel?.inputs.update(updateMemo: MemoData(title: self?.titleTextView.textField.text,
                                                                                  memo: self?.memoTextView.textView.text,
                                                                                  date: self?.memoData.date,
                                                                                  identifier: self?.memoData.identifier!,
                                                                                  imageArray: self?.memoData.imageArray)) ?? (false, nil)
          if bool {
            self?.navigationController?.popViewController(animated: true)
          }else {
            debugPrint(error!)
          }
        }
      }).disposed(by: disposeBag)
    
  }
  lazy var navView: BasePopNavView = {
    let view = BasePopNavView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var scrollView: UIScrollView = {
    let scroll = UIScrollView()
    //    scroll.backgroundColor = .systemBlue
    scroll.translatesAutoresizingMaskIntoConstraints = false
    return scroll
  }()
  lazy var titleTextView: MemoTextFieldView = {
    let view = MemoTextFieldView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var memoTextView: MemoTextView = {
    let view = MemoTextView()
    view.textView.delegate = self
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var photoLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "📸 사진"
    label.font = .sb18
    return label
  }()
  lazy var photoCollect: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.itemSize = CGSize(width: 100, height: 100)
    layout.minimumLineSpacing = 16
    layout.minimumInteritemSpacing = 0
    let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
    view.contentInset = UIEdgeInsets(top: 0, left: 46, bottom: 0, right: 46)
    view.showsHorizontalScrollIndicator = false
    view.backgroundColor = .white
    view.delegate = self
    view.dataSource = self
    view.translatesAutoresizingMaskIntoConstraints = false
    view.register(MemoPhotoAddPhotoCell.self, forCellWithReuseIdentifier: "addCell")
    return view
  }()
  
  @objc func keyboardWillShow(_ notification: Notification){
    guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
    let keyboardHeight = keyboardFrame.height
    let bottom = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
    self.height = (view.frame.height - memoTextView.frame.minY - keyboardHeight - 46 - bottom)
    //
    //    DispatchQueue.main.async {
    //      UIView.animate(withDuration: 0.33, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
    //        self.textViewHeight?.constant = height
    //        }, completion: nil)
    //      self.view.layoutIfNeeded()
    //    }
  }
  @objc func keyboardWillHide(_ notification: Notification){
    
  }
}

extension MemoDetailViewController: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    print(self.memoTextView.frame.minY)
    if textView == self.memoTextView.textView {
      self.lastScrollOffset = self.scrollView.contentOffset.y
      self.scrollView.setContentOffset(CGPoint(x: 0, y:  self.memoTextView.frame.minY - 32), animated: true)
      
      //      print(height)
      DispatchQueue.main.async {
        self.textViewHeight?.constant = self.height
        UIView.animate(withDuration: 0.22, animations: {
          self.view.layoutIfNeeded()
        }) { (_) in
          UIView.animate(withDuration: 0.22, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            //          self.scrollView.contentOffset.y = self.memoTextView.frame.minY - 32
          }, completion: nil)
        }
        //      self.view.layoutIfNeeded()
      }
    }
  }
  func textViewDidEndEditing(_ textView: UITextView) {
    if textView == self.memoTextView.textView {
      scrollView.setContentOffset(CGPoint(x: 0, y: self.lastScrollOffset ?? 0), animated: true)
      DispatchQueue.main.async {
        self.textViewHeight?.constant = self.memoTextView.textView.contentSize.height
        UIView.animate(withDuration: 0.33, animations: {
          self.view.layoutIfNeeded()
        }, completion: nil)
      }
    }
    //    print(memoTextView.textView.contentSize.height)
  }
  func textViewDidChange(_ textView: UITextView) {
    if textView == self.memoTextView.textView {
      //      let size = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.greatestFiniteMagnitude))
      //    textViewHeightConstraint.constant = size.height
      //      print(size)
      view.layoutIfNeeded()
    }
  }
  func openPhotoPicker(){
    let picker: UIImagePickerController = UIImagePickerController()
    picker.delegate = self
    picker.allowsEditing = true
    picker.sourceType = .photoLibrary
    picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
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
    picker.allowsEditing = true
    picker.sourceType = .camera
    DispatchQueue.main.async {
      weak var pvc = self.presentedViewController
      pvc?.dismiss(animated: true) {
        self.present(picker, animated: true, completion: nil)
      }
    }
  }
}

extension MemoDetailViewController: MemoDetailDelegate {
  func memoDetailPopup(type: MemoDetailPopupType) {
    switch type {
    case .delete:
      let (bool, _) = self.viewModel?.inputs.delete(identifier: (self.memoData.identifier!)) ?? (false, nil)
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
    if self.memoData.imageArray == nil {
      self.memoData.imageArray = [image]
    }else {
      self.memoData.imageArray?.append(image)
    }
    self.photoCollect.reloadData()
  }
  
}

extension MemoDetailViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if currentDetailType == MemoDetailType.Add || currentDetailType == MemoDetailType.Edit {
      if indexPath.row == self.memoData.imageArray?.count ?? 0 {
        let vc = MemoBottomPopupViewController(data: (self.viewModel?.outputs.memoAddImage)!)
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
      }
    }else {
      
    }
  }
}

extension MemoDetailViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if currentDetailType == MemoDetailType.Add || currentDetailType == MemoDetailType.Edit {
      return (self.memoData.imageArray?.count ?? 0) + 1
    }else {
      return self.memoData.imageArray?.count ?? 0
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath) as! MemoPhotoAddPhotoCell
    if indexPath.row == self.memoData.imageArray?.count {
      cell.configure(image: nil)
    }else {
      cell.configure(image: self.memoData.imageArray?[indexPath.row])
    }
    return cell
  }
  
}

extension MemoDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  //MARK: UIImagePickerControllerDelegate
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    if let chosenImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
//      images.append(chosenImage)
      if self.memoData.imageArray == nil {
        debugPrint(self.memoData.imageArray)
        self.memoData.imageArray = [chosenImage]
        debugPrint(self.memoData.imageArray)
      }else {
        self.memoData.imageArray?.append(chosenImage)
      }
      self.photoCollect.reloadData()
    }
    picker.dismiss(animated: true, completion: nil)
  }
}
