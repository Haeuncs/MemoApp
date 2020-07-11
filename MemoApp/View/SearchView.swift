//
//  SearchView.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/04/05.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

class SearchView: UIButton {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
    self.backgroundColor = Color.veryLightGrey
    self.layer.cornerRadius = 8
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func initView() {
    self.addSubview(searchImageView)
    self.addSubview(textField)
    
    searchImageView.snp.makeConstraints { (make) in
      make.leading.equalToSuperview().offset(8)
      make.centerY.equalToSuperview()
      make.width.height.equalTo(20)
    }
    textField.snp.makeConstraints { (make) in
      make.top.bottom.equalToSuperview()
      make.trailing.equalToSuperview()
      make.leading.equalTo(searchImageView.snp.trailing).offset(8)
    }
  }
  lazy var searchImageView: UIImageView = {
    let view = UIImageView()
    view.isUserInteractionEnabled = false
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    view.image = UIImage(named: "searchIcn")
    return view
  }()
  
  lazy var textField: UITextField = {
    let text = UITextField()
    text.isUserInteractionEnabled = false
    text.translatesAutoresizingMaskIntoConstraints = false
    text.font = .sb14
    text.textColor = Color.grey
    text.tintColor = Color.grey
    text.attributedPlaceholder = NSAttributedString(
      string: "검색어 입력",
      attributes:
      [NSAttributedString.Key.foregroundColor: Color.grey,
       NSAttributedString.Key.font: UIFont.sb14])

    return text
  }()
}
