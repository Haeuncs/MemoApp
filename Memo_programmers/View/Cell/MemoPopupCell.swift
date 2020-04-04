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
  let image: UIImage
  let title: String
}

private enum Style {
  static let backgroundColor: UIColor = Color.background
  enum Image {
    static let height: CGFloat = 34
    static let width: CGFloat = 34
  }
  enum Title {
    static let marginLeft: CGFloat = 10
    static let font: UIFont = .r14
    static let selectedFont: UIFont = .sb14
  }
}

class MemoPopupCell: BaseTableCell {
  func configure(data: MemoEdit, isSelected: Bool = false) {
    self.iconImage.image = data.image.withRenderingMode(.alwaysTemplate)
    self.titleLabel.text = data.title
    if isSelected {
      self.titleLabel.font = Style.Title.selectedFont
      self.titleLabel.textColor = Color.selectedColor
    } else {
      self.titleLabel.font = Style.Title.font
      self.titleLabel.textColor = Color.black
    }

  }
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.backgroundColor = Style.backgroundColor
    baseView.addSubview(iconImage)
    baseView.addSubview(titleLabel)

    iconImage.snp.makeConstraints { (make) in
      make.width.height.equalTo(Style.Image.height)
      make.centerY.equalTo(baseView)
      make.leading.equalTo(baseView)
    }
    titleLabel.snp.makeConstraints { (make) in
      make.centerY.equalTo(baseView)
      make.leading.equalTo(iconImage.snp.trailing).offset(Style.Title.marginLeft)
      make.trailing.equalTo(baseView)
    }
    setAppearance()
  }
  func setAppearance() {
    self.backgroundColor = Color.background
    iconImage.tintColor = Color.black
    titleLabel.font = Style.Title.font
    titleLabel.textColor = Color.black
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  lazy var iconImage: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .center
    return view
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

}
