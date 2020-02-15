//
//  BaseView.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/13.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class BaseView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    self.addSubview(baseView)
    baseView.snp.makeConstraints { (make) in
      make.top.bottom.equalTo(self)
      make.leading.equalTo(self).offset(16)
      make.trailing.equalTo(self).offset(-16)
    }
    
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  lazy var baseView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

}

