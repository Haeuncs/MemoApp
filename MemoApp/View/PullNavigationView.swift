//
//  PullNavigationView.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/13.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class PullNavigationView: BaseView {
  override init(frame: CGRect) {
    super.init(frame: frame)

    baseView.addSubview(leftButton)
    baseView.addSubview(titleLabel)
    baseView.addSubview(doneButton)
    baseView.addSubview(lineView)

    titleLabel.snp.makeConstraints { (make) in
      make.center.equalTo(baseView)
    }
    leftButton.snp.makeConstraints { (make) in
      make.leading.equalTo(baseView)
      make.centerY.equalTo(baseView)
    }
    doneButton.snp.makeConstraints { (make) in
      make.trailing.equalTo(baseView)
      make.centerY.equalTo(baseView)
    }
    lineView.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(12)
      make.bottom.equalTo(baseView)
      make.leading.trailing.equalTo(self)
      make.height.equalTo(1)
    }
    setAppearance()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func setAppearance() {
    doneButton.setTitleColor(Color.black, for: .normal)
    doneButton.setTitle("완료", for: .normal)
    doneButton.titleLabel?.font = .sb12
    leftButton.titleLabel?.font = .sb12
    titleLabel.textColor = Color.black
    titleLabel.font = .sb16
    lineView.backgroundColor = Color.veryLightGrey
  }
  lazy var imageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    view.image = UIImage(named: "28")
    return view
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  lazy var doneButton: BaseButton = {
    let button = BaseButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  lazy var leftButton: BaseButton = {
    let button = BaseButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  lazy var lineView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

}
