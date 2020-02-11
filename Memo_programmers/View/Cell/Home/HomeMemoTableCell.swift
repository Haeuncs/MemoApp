//
//  HomeMemoTableCell.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/11.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class HomeMemoTableCell: BaseTableCell {
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    
    baseView.addSubview(titleLabel)
    baseView.addSubview(memoLabel)
    baseView.addSubview(dateLabel)
    baseView.addSubview(memoImageView)
    baseView.addSubview(lineView)
    
    titleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(baseView.snp.top).offset(18)
      make.leading.trailing.equalTo(baseView)
    }
    
    memoLabel.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.leading.equalTo(baseView)
      make.trailing.equalTo(memoImageView.snp.leading).offset(-16)
    }
    
    dateLabel.snp.makeConstraints { (make) in
      make.top.equalTo(memoLabel.snp.bottom).offset(16)
      make.leading.equalTo(baseView)
      make.bottom.equalTo(lineView.snp.top).offset(-16)
    }
    
    lineView.snp.makeConstraints { (make) in
      make.height.equalTo(1)
      make.bottom.leading.trailing.equalTo(baseView)
    }
    
    memoImageView.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.top)
      make.width.height.equalTo(90)
//      make.centerY.equalTo(baseView)
      make.trailing.equalTo(baseView)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "아직 여행 일정이 없어요."
    label.font = UIFont.sb28
    label.textColor = UIColor.memo_black
    return label
  }()
  lazy var memoLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "아직 여행 일정이 없어요."
    label.numberOfLines = 3
    label.font = UIFont.m14
    label.textColor = UIColor.memo_grey
    return label
  }()
  lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "아직 여행 일정이 없어요."
    label.font = UIFont.sb12
    label.textColor = UIColor.memo_black
    return label
  }()
  lazy var memoImageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFill
    view.clipsToBounds = true
    view.image = UIImage(named: "cute")
    return view
  }()
  lazy var lineView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.memo_grey
    return view
  }()

}

