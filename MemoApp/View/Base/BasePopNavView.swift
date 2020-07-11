//
//  BasePopNavView.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/11.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class BasePopNavView: UIView {
  func configure(type: MemoDetailType) {
    switch type {
    case .edit:
      self.dotButton.isHidden = true
      self.titleButton.isHidden = false
      self.titleButton.setTitle("수정 완료", for: .normal)
    case .add:
      self.dotButton.isHidden = true
      self.titleButton.isHidden = false
      self.titleButton.setTitle("저장", for: .normal)
    case .read:
      self.dotButton.setImage(UIImage(named: "dot")?.withRenderingMode(.alwaysTemplate), for: .normal)
      self.dotButton.isHidden = false
      self.titleButton.isHidden = true
    }
  }
  override init(frame: CGRect) {
    super.init(frame: frame)

    self.addSubview(titleLabel)
    self.addSubview(popButton)
    self.addSubview(dotButton)
    self.addSubview(titleButton)
    //    self.addSubview(saveLabel)
    titleLabel.snp.makeConstraints { (make) in
//      make.leading.trailing.top.bottom.lessThanOrEqualTo(self)
      make.centerX.centerY.equalTo(self)
    }
    popButton.snp.makeConstraints { (make) in
      make.leading.centerY.equalTo(self)
      make.height.equalTo(34)
    }
    dotButton.snp.makeConstraints { (make) in
      make.trailing.centerY.equalTo(self)
      make.height.equalTo(34)
    }
    titleButton.snp.makeConstraints { (make) in
      make.trailing.centerY.equalTo(self)
      make.height.equalTo(34)
    }
    //    saveLabel.snp.makeConstraints { (make) in
    //      make.trailing.bottom.equalTo(self)
    //    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func setAppearance() {
    self.popButton.tintColor = Color.black
    dotButton.imageView?.tintColor = Color.black
    titleButton.setTitleColor(Color.black, for: .normal)
    saveLabel.textColor = Color.black
  }
  lazy var popButton: PopButton = {
    let view = PopButton()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var dotButton: BaseButton = {
    let button = BaseButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .sb18
    return label
  }()
  lazy var titleButton: BaseButton = {
    let button = BaseButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.titleLabel?.font = .sb12
    button.setTitleColor(Color.black, for: .normal)
    return button
  }()
  lazy var saveLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .sb12
    return label
  }()

}
