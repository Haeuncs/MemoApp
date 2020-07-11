//
//  HomeMemoWithoutImageTableCell.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/20.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class HomeMemoWithoutImageTableCell: BaseTableCell {

  func configure(title: String?, memo: String?, date: Date?, image: UIImage? = nil) {
    if title == nil {
      self.titleLabel.text = " "
    } else {
      self.titleLabel.text = title
    }
    if memo == nil {
      self.memoLabel.text = " "
    } else {
      self.memoLabel.text = memo
    }
    if date == nil {
      self.dateLabel.text = " "
    } else {
      self.dateLabel.text = date!.korDateString()
    }
  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.backgroundColor = Color.background
//    self.selectionStyle = .none
    baseView.addSubview(titleLabel)
    baseView.addSubview(memoLabel)
    baseView.addSubview(dateLabel)
    baseView.addSubview(lineView)

    titleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(baseView.snp.top).offset(18)
      make.leading.trailing.equalTo(baseView)
    }

    memoLabel.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(16)
      make.leading.equalTo(baseView)
      make.trailing.equalTo(baseView).offset(-16)
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

  }
  override func layoutSubviews() {
    super.layoutSubviews()
    setAppearance()
  }
  func setAppearance() {
    self.titleLabel.textColor = Color.black
    self.memoLabel.textColor = Color.grey
    self.dateLabel.textColor = Color.black
    self.lineView.backgroundColor = Color.grey
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "아직 여행 일정이 없어요."
    label.font = UIFont.sb28
    label.textColor = Color.black
    return label
  }()
  lazy var memoLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "아직 여행 일정이 없어요."
    label.numberOfLines = 3
    label.font = UIFont.m14
    label.textColor = Color.grey
    return label
  }()
  lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "아직 여행 일정이 없어요."
    label.font = UIFont.sb12
    label.textColor = Color.black
    return label
  }()
  lazy var lineView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = Color.grey
    return view
  }()

}
