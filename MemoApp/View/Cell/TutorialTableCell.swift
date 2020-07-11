//
//  TutorialTableCell.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/24.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class TutorialTableCell: UITableViewCell {
  func configure(type: TutorialType) {
    self.thumbImage.image = type.image
    self.titleLabel.text = type.title
    self.detailLabel.text = type.subTitle
  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.selectionStyle = .none
    self.backgroundColor = Color.background
    self.titleLabel.textColor = Color.black
    self.detailLabel.textColor = Color.black
    self.addSubview(thumbImage)
    self.addSubview(titleLabel)
    self.addSubview(detailLabel)

    thumbImage.snp.makeConstraints { (make) in
      make.top.leading.equalTo(self)
      make.width.height.equalTo(40)
    }
    titleLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(thumbImage.snp.trailing).offset(Constant.UI.Size.margin)
      make.top.trailing.equalTo(self)
    }
    detailLabel.snp.makeConstraints { (make) in
      make.top.equalTo(titleLabel.snp.bottom).offset(4)
      make.leading.equalTo(thumbImage.snp.trailing).offset(Constant.UI.Size.margin)
      make.trailing.equalTo(self)
      make.bottom.lessThanOrEqualTo(self)
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  lazy var thumbImage: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    view.image = UIImage(named: "emptyMemoLight")
    return view
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "아직 여행 일정이 없어요."
    label.font = .sb14
    label.numberOfLines = 0
    return label
  }()
  lazy var detailLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "아직 여행 일정이 없어요."
    label.font = .r12
    label.numberOfLines = 0
    return label
  }()
}
