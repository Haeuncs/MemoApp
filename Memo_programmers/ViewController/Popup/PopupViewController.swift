//
//  PopupViewController.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/04/03.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class PopupViewController: UIViewController {
  private var disposeBag = DisposeBag()
  private let data: PopupData
  init(data: PopupData) {
    self.data = data
    super.init(nibName: nil, bundle: nil)
    self.modalPresentationStyle = .overFullScreen
    self.modalTransitionStyle = .crossDissolve
    self.bodyLabel.text = data.body
    self.leftButton.setTitle(data.left, for: .normal)
    self.rightButton.setTitle(data.right, for: .normal)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.view.backgroundColor = Color.dim
    initView()
    bindRx()
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
  }

  // MARK: - View ✨

  func initView() {
    view.addSubview(popupView)
    popupView.addSubview(bodyLabel)
    popupView.addSubview(buttonStack)
    popupView.snp.makeConstraints { (make) in
      make.width.equalTo(280)
      make.center.equalToSuperview()
    }
    bodyLabel.snp.makeConstraints { (make) in
      make.top.equalTo(Constant.UI.Size.margin)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalTo(buttonStack.snp.top).offset(-Constant.UI.Size.margin)
    }
    buttonStack.snp.makeConstraints { (make) in
      make.leading.trailing.bottom.equalToSuperview()
      make.height.equalTo(40)
    }
  }

  // MARK: - Bind 🏷

  func bindRx() {
    self.leftButton.rx.tap
      .subscribe(onNext: { [weak self] (_) in
        self?.dismiss(animated: true, completion: nil)
      }).disposed(by: disposeBag)

    self.rightButton.rx.tap
      .subscribe(onNext: { [weak self] (_) in
        if let handler = self?.data.rightHandler {
          handler()
        }
      }).disposed(by: disposeBag)

  }
  lazy var popupView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = Color.background
    view.layer.cornerRadius = Constant.UI.radius
    return view
  }()

  lazy var bodyLabel: UILabel = {
    let label = UILabel()
    label.font = .m16
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  lazy var buttonStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [leftButton, rightButton])
    stack.alignment = .fill
    stack.distribution = .fillEqually
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .horizontal
    return stack
  }()

  lazy var leftButton: UIButton = {
    let button = UIButton()
    button.titleLabel?.font = .m14
    button.setTitleColor(Color.grey, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  lazy var rightButton: UIButton = {
    let button = UIButton()
    button.titleLabel?.font = .m14
    button.setTitleColor(Color.black, for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

}
