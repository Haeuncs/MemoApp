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
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "🏷 제목"
    label.font = .sb18
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
    text.placeholder = "제목을 입력해주세요."
    text.clearButtonMode = UITextField.ViewMode.whileEditing
    text.textColor = .black
    text.font = .m18
    text.tintColor = .black
    return text
  }()

  lazy var lineView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = .memo_grey
    return view
  }()

}
