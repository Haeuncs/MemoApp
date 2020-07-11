//
//  HomeMemoTableCell.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/11.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class HomeMemoTableCell: BaseTableCell {

  typealias Style = Constant.MemoHome.Cell

  func configure(title: String?, memo: String?, date: Date?, image: UIImage? = nil) {
    if memo?.count ?? 0 <= 0 {
      self.memoLabel.text = "내용 없음"
    } else {
      self.memoLabel.text = memo
    }
    if title?.count ?? 0 <= 0 {
      self.titleLabel.text = "무제"
    } else {
      self.titleLabel.text = title
    }
    self.dateLabel.text = date!.korDateString()
    self.memoImageView.image = image
  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    baseView.addSubview(titleLabel)
    baseView.addSubview(memoLabel)
    baseView.addSubview(dateLabel)
    baseView.addSubview(memoImageView)
    baseView.addSubview(lineView)

    titleLabel.snp.makeConstraints { (make) in
      make.top.equalTo(baseView.snp.top).offset(18)
      make.leading.equalTo(baseView)
      make.trailing.equalTo(memoImageView.snp.leading)
        .offset(-Constant.UI.Size.margin)
    }

    memoLabel.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom)
        .offset(Constant.UI.Size.margin)
      make.leading.equalTo(baseView)
      make.trailing.equalTo(memoImageView.snp.leading)
        .offset(-Constant.UI.Size.margin)
    }

    dateLabel.snp.makeConstraints { (make) in
      make.top.equalTo(memoLabel.snp.bottom).offset(Constant.UI.Size.margin)
      make.leading.equalTo(baseView)
      make.bottom.equalTo(lineView.snp.top).offset(-Constant.UI.Size.margin)
    }

    lineView.snp.makeConstraints { (make) in
      make.height.equalTo(Style.dividerLineHeight)
      make.bottom.leading.trailing.equalTo(baseView)
    }

    memoImageView.snp.makeConstraints { (make) in
      make.top.lessThanOrEqualTo(titleLabel.snp.bottom)
      make.width.height.equalTo(Style.imageHeight)
      make.trailing.equalTo(baseView)
      make.bottom.equalTo(lineView.snp.top).offset(-Constant.UI.Size.margin)
    }
  }
  override func layoutSubviews() {
    super.layoutSubviews()
    setAppearance()
  }
  func setAppearance() {
    self.backgroundColor = Color.background
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
    label.font = UIFont.sb28
    label.textColor = Color.black
    return label
  }()
  lazy var memoLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = Style.memoLines
    label.font = UIFont.m14
    label.textColor = Color.grey
    return label
  }()
  lazy var dateLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.sb12
    label.textColor = Color.black
    return label
  }()
  lazy var memoImageView: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFill
    view.clipsToBounds = true
    view.layer.cornerRadius = Style.imageRadius
    return view
  }()
  lazy var lineView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = Color.grey
    return view
  }()

}
