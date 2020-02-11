//
//  HomeNavView.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/11.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class HomeNavigationView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.addSubview(titleLabel)
    self.addSubview(lineView)
    
    titleLabel.snp.makeConstraints { (make) in
      make.top.lessThanOrEqualTo(self)
      make.leading.trailing.equalTo(self)
      make.bottom.equalTo(lineView.snp.top)
    }
    lineView.snp.makeConstraints { (make) in
      make.leading.trailing.bottom.equalTo(self)
      make.height.equalTo(4)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Memo"
    label.textColor = UIColor.memo_black
    label.font = UIFont.h28
    return label
  }()

  lazy var lineView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.memo_black
    return view
  }()

}
