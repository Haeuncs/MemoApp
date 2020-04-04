//
//  MemoTextField.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/12.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class MemoTextFieldView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setAppearance()
    
    self.backgroundColor = Color.background

    self.addSubview(titleLabel)
    self.addSubview(stackView)
    titleLabel.snp.makeConstraints { (make) in
      make.top.leading.trailing.equalTo(self)
    }
    stackView.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.trailing.bottom.equalTo(self)
      make.leading.equalTo(self).offset(30)
    }
    textField.snp.makeConstraints { (make) in
      make.height.equalTo(28)
    }
    lineView.snp.makeConstraints { (make) in
      make.height.equalTo(2)
    }
    
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setAppearance() {
    self.backgroundColor = Color.background
    titleLabel.textColor = Color.black
    textField.textColor = Color.black
    textField.tintColor = Color.black
    lineView.backgroundColor = Color.grey
  }
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .sb14
    label.textColor = Color.black
    return label
  }()
  lazy var stackView: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [textField, lineView])
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.spacing = 2
//    stack.alignment = .center
    return stack
  }()
  lazy var textField: UITextField = {
    let text = UITextField()
    text.clearButtonMode = UITextField.ViewMode.whileEditing
    text.textColor = Color.black
    text.font = .m18
    text.tintColor = Color.black
    return text
  }()

  lazy var lineView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = Color.grey
    return view
  }()

}
