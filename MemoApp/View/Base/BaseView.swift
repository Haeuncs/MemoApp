//
//  BaseView.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/13.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

/**
 마진 적용 베이스 뷰
 */
class BaseView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)

    self.addSubview(baseView)
    baseView.snp.makeConstraints { (make) in
      make.top.bottom.equalTo(self)
      make.leading.equalTo(self).offset(Constant.UI.Size.margin)
      make.trailing.equalTo(self).offset(-Constant.UI.Size.margin)
    }

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  lazy var baseView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

}
