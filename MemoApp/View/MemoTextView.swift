//
//  MemoTextView.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/12.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class MemoTextView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)

    self.addSubview(titleLabel)
    self.addSubview(baseView)
    baseView.addSubview(textView)
    baseView.addSubview(lineView)

    titleLabel.snp.makeConstraints { (make) in
      make.top.leading.trailing.equalTo(self)
    }
    baseView.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.trailing.bottom.equalTo(self)
      make.leading.equalTo(self).offset(30)
    }
    textView.snp.makeConstraints { (make) in
      make.top.equalTo(baseView.snp.top)
      make.leading.trailing.equalTo(baseView  )
      make.bottom.equalTo(lineView.snp.top)
    }
    lineView.snp.makeConstraints { (make) in
      make.height.equalTo(2)
      make.leading.trailing.equalTo(baseView)
      make.bottom.equalTo(baseView)
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func setAppearance() {
    self.backgroundColor = Color.background
    textView.backgroundColor = Color.background
    titleLabel.textColor = Color.black
    textView.textColor = Color.black
    textView.tintColor = Color.black
    lineView.backgroundColor = Color.grey
  }

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .sb14
    label.textColor = Color.black
    return label
  }()
  lazy var baseView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var textView: UITextView = {
    let text = UITextView()
    text.backgroundColor = Color.background
    text.translatesAutoresizingMaskIntoConstraints = true
    text.isScrollEnabled = false
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
