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
    self.addSubview(baseView)
    baseView.snp.makeConstraints { (make) in
      make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
      make.leading.equalTo(self.snp.leading).offset(16)
      make.trailing.equalTo(self.snp.trailing).offset(-16)
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
