//
//  PopButton.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/21.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

private enum Style {
  enum Image {
    static let height: CGFloat = 34
    static let image: UIImage = UIImage(named: "arrowLeft")!.withRenderingMode(.alwaysTemplate)
  }
  enum Title {
    static let font: UIFont = .sb14
    static let color: UIColor = Color.black
    static let marginLeft: CGFloat = 6
  }
}
class PopButton: BaseButton {

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.addSubview(popImage)
    self.addSubview(popLabel)

    popImage.snp.makeConstraints { (make) in
      make.width.equalTo(Style.Image.height)
      make.top.bottom.leading.equalTo(self)
    }
    popLabel.snp.makeConstraints { (make) in
      make.leading.equalTo(popImage.snp.trailing).offset(Style.Title.marginLeft)
      make.trailing.equalTo(self)
      make.centerY.equalTo(self)
    }

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  lazy var popImage: UIImageView = {
    let view = UIImageView()
    view.image = Style.Image.image
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    return view
  }()
  lazy var popLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = Style.Title.font
    label.textColor = Style.Title.color
    return label
  }()

}
