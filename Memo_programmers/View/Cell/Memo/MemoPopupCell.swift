//
//  MemoPopupCell.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/13.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

struct MemoEdit {
  let iconSysName: String
  let title: String
}

class MemoPopupCell: BaseTableCell {
  
  func configure(data: MemoEdit) {
    let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 22), scale: .small)
    let image = UIImage(systemName: data.iconSysName, withConfiguration: config)
    image?.withRenderingMode(.alwaysTemplate)
    self.iconImage.image = image
    self.titleLabel.text = data.title
    
  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    baseView.addSubview(iconImage)
    baseView.addSubview(titleLabel)
    
    iconImage.snp.makeConstraints { (make) in
      make.width.height.equalTo(34)
      make.centerY.equalTo(baseView)
      make.leading.equalTo(baseView)
    }
    titleLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(baseView)
      make.leading.equalTo(iconImage.snp.trailing).offset(10)
      make.trailing.equalTo(baseView)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var iconImage: UIImageView = {
    let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 22), scale: .small)
    let image = UIImage(systemName: "plus.square.on.square", withConfiguration: config)
    image?.withRenderingMode(.alwaysTemplate)
    let view = UIImageView()
    view.tintColor = .memo_black
    view.image = image
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .center
    return view
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "아직 여행 일정이 없어요."
    label.font = .r14
    return label
  }()

}
