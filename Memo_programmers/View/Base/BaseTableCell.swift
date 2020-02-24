//
//  BaseTableCell.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/11.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class BaseTableCell: UITableViewCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    let backgroundView = UIView()
    backgroundView.backgroundColor = Color.selectionColor
    self.selectedBackgroundView = backgroundView
    self.addSubview(baseView)
    baseView.snp.makeConstraints { (make) in
      if #available(iOS 11.0, *) {
        make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
      } else {
        // Fallback on earlier versions
        make.top.equalTo(self.snp.top)
      }
      make.leading.equalTo(self.snp.leading).offset(Constant.UI.Size.margin)
      make.trailing.equalTo(self.snp.trailing).offset(-Constant.UI.Size.margin)
      make.bottom.equalTo(self)
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
