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
    // UITextView에서 Place holder를 쓰기위해 주석 처리
    // textView.textColor = Color.black
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
    // UITextView에서 Place holder를 쓰기위해 주석 처리
    // text.textColor = Color.black
    text.text = "Add contents here."
    // 회색을 Placeholder로 생각 (UITextField와 동일 색상)
    text.textColor = Color.grey
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

extension MemoTextView: UITextViewDelegate {
  func textViewDidBeginEditing(_ textView: UITextView) {
    guard textView.textColor == Color.grey else { return }
    textView.textColor = .white
    textView.text = nil
  }

  func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
      textView.text = "Add contents here."
      textView.textColor = Color.grey
    }
  }
  
}