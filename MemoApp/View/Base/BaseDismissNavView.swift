//
//  BaseDismissNavView.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/23.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class BaseDismissNavView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)

    self.addSubview(dismissButton)
    dismissButton.snp.makeConstraints { (make) in
      make.top.leading.trailing.bottom.equalTo(self)
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  lazy var dismissButton: DismissButton = {
    let view = DismissButton()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
}
