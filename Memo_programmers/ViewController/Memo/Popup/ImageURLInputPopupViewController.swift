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

class ImageURLInputPopupViewController: BasePullDownViewController {
  
  // MARK: - Properties
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
  
  // MARK: - Init
  init() {
    super.init(nibName: nil, bundle: nil)
    self.modalPresentationStyle = .overFullScreen
    self.modalTransitionStyle = .crossDissolve
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    initView()
    bindRx()
    self.currentImageURLType = .load
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.titleTextView.textField.becomeFirstResponder()
  }
  
  // MARK: - View ✨
  func initView() {
    navView.titleLabel.text = "URL 로 입력하기"
    navView.leftButton.setTitle("취소", for: .normal)
    contentView.addSubview(containerView)
    containerView.addSubview(titleTextView)
    containerView.addSubview(loadImageView)
    containerView.addSubview(failureView)
    
    self.contentView.snp.makeConstraints { (make) in
      if #available(iOS 11.0, *) {
        make.top.equalTo(self.view.safeAreaLayoutGuide)
      } else {
        // Fallback on earlier versions
        make.top.equalTo(self.view)
      }
    }
    containerView.snp.makeConstraints { (make) in
      make.top.equalTo(navView.snp.bottom).offset(16)
      make.leading.equalTo(contentView).offset(16)
      make.trailing.equalTo(contentView).offset(-16)
      make.bottom.equalTo(contentView)
    }
    titleTextView.snp.makeConstraints { (make) in
      make.top.leading.trailing.equalTo(containerView)
    }
    loadImageView.snp.makeConstraints { (make) in
      make.top.equalTo(titleTextView.snp.bottom)
      make.leading.trailing.bottom.equalTo(containerView)
    }
    failureView.snp.makeConstraints { (make) in
      make.top.equalTo(titleTextView.snp.bottom)
      make.leading.trailing.bottom.equalTo(containerView)
    }
    bottomConstraints = containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -16)
    bottomConstraints?.isActive = true
  }
  
  // MARK: - Bind 🏷
  func bindRx(){
    self.navView.doneButton.rx.tap
      .subscribe(onNext: { (_) in
        switch self.currentImageURLType! {
        case .load:
          self.loadUrlImage()
        case .save:
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
    return view
  }()
  
  lazy var failureView: URLFailureView = {
    let view = URLFailureView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.isHidden = true
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
    self.loadImageView.kf.indicatorType = .activity
    self.loadImageView.kf.setImage(with: URL(string: self.titleTextView.textField.text ?? "")){ result in
      switch result {
      case .success(_):
        self.currentImageURLType = .save
        self.failureView.isHidden = true
      case .failure(_):
        self.currentImageURLType = .load
        self.failureView.isHidden = false
      }
    }
  }
  
  @objc func keyboardWillShow(_ notification: Notification){
    guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
    let keyboardHeight = keyboardFrame.height
    
    self.bottomConstraints?.constant = -keyboardHeight
    
    UIView.animate(withDuration: 0.33, delay: 0, options: UIView.AnimationOptions.curveLinear, animations: {
      self.view.layoutIfNeeded()
    }, completion: nil)
  }
  
  @objc func textFieldChanged(_ textField: UITextField){
    self.currentImageURLType = .load
  }
}
