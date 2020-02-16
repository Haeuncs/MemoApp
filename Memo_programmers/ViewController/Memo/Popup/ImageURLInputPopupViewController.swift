//
//  ImageURLInputPopupViewController.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/11.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

enum ImageURLType {
  case load
  case save
}
class ImageURLInputPopupViewController: BasePullDownViewController {
  
  public weak var delegate: MemoDetailLoadURLImageDelegate?
  
  private var disposeBag = DisposeBag()
  private var bottomConstraints: NSLayoutConstraint?
  private var height: CGFloat = 0
  private var currentImageURLType: ImageURLType? {
    didSet {
      guard let current = currentImageURLType else {
        return
      }
      self.setCurrentImageURLType(type: current)
    }
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
    bindRx()
    self.currentImageURLType = .load
    // MARK: keyboard
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.titleTextView.textField.becomeFirstResponder()
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }
  // View ✨
  func initView(){
    navView.titleLabel.text = "URL 로 입력하기"
    navView.leftButton.setTitle("취소", for: .normal)
    contentView.addSubview(containerView)
    containerView.addSubview(titleTextView)
    containerView.addSubview(loadImageView)
    
    containerView.snp.makeConstraints { (make) in
      make.top.equalTo(navView.snp.bottom).offset(16)
      make.leading.equalTo(contentView).offset(16)
      make.trailing.equalTo(contentView).offset(-16)
    }
    titleTextView.snp.makeConstraints { (make) in
      make.top.leading.trailing.equalTo(containerView)
    }
    loadImageView.snp.makeConstraints { (make) in
      make.top.equalTo(titleTextView.snp.bottom)
      make.leading.trailing.bottom.equalTo(containerView)
    }
    bottomConstraints = containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16)
    bottomConstraints?.isActive = true
  }
  // Bind 🏷
  func bindRx(){
    self.navView.doneButton.rx.tap
      .subscribe(onNext: { (_) in
        switch self.currentImageURLType! {
        case .load:
          self.loadUrlImage()
        case .save:
          // 여기에 delegate 적용
          self.delegate?.addLoadURLImage(image: self.loadImageView.image ?? UIImage())
          self.dismiss(animated: true, completion: nil)
        }
      }).disposed(by: disposeBag)
    
    self.navView.leftButton.rx.tap
      .subscribe(onNext: { [weak self] (_) in
        self?.dismiss(animated: true, completion: nil)
      }).disposed(by: disposeBag)
  }
  lazy var containerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  lazy var titleTextView: MemoTextFieldView = {
    let view = MemoTextFieldView()
    view.titleLabel.text = "URL 로 입력하기"
    view.textField.placeholder = "이미지 URL을 입력해주세요."
    view.translatesAutoresizingMaskIntoConstraints = false
    view.textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    return view
  }()
  lazy var loadImageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    view.backgroundColor = .systemPink
    return view
  }()

  func setCurrentImageURLType(type: ImageURLType){
    switch type {
    case .load:
      navView.doneButton.setTitle("로드", for: .normal)
    case .save:
      navView.doneButton.setTitle("저장", for: .normal)
    }
  }
  @objc func loadUrlImage(){
    self.loadImageView.kf.setImage(with: URL(string: self.titleTextView.textField.text ?? "")){ result in
        switch result {
        case .success(_):
          self.currentImageURLType = .save
        case .failure(let error):
          self.currentImageURLType = .load
        }
    }
  }
  @objc func keyboardWillShow(_ notification: Notification){
    guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
    let keyboardHeight = keyboardFrame.height
    let bottom = UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0
//    self.height = (view.frame.height - contentView.frame.minY - keyboardHeight - bottom)
    print(bottom)
    print(height)
          self.bottomConstraints?.constant = -keyboardHeight
          UIView.animate(withDuration: 0.33, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.view.layoutIfNeeded()
          }, completion: nil)
  }
  @objc func textFieldChanged(_ textField: UITextField){
    self.currentImageURLType = .load
  }
}
