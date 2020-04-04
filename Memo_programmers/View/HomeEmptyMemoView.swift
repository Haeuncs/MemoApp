//
//  HomeEmptyMemoView.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/22.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

private enum Style {
  enum Arrow {
    static let topMargin: CGFloat = 24
    static let rightMargin: CGFloat = 12
    static let text: String = "메모를\n추가해보세요."
    static let textColor: UIColor = Color.black
    static let textFont: UIFont = .sb18
  }
  enum Light {
    static let space: CGFloat = 20
    static let image: UIImage = UIImage(named: "emptyMemoLight")!
    static let text: String = "추가한 메모가 여기에 표시됩니다."
    static let textColor: UIColor = Color.grey
    static let textFont: UIFont = .sb14
  }
}
class HomeEmptyMemoView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // MARK: - InitView
  func initView() {
    self.addSubview(arrowLabel)
    self.addSubview(lightStack)

    arrowLabel.snp.makeConstraints { (make) in
      make.bottom.equalTo(self).offset(-19-Constant.UI.safeInsetBottomiOS10)
      make.trailing.equalTo(self).offset(-82)
    }
    lightStack.snp.makeConstraints { (make) in
      make.centerX.equalTo(self)
      make.centerY.equalTo(self)
      make.leading.trailing.lessThanOrEqualTo(self)
    }
  }
  lazy var arrowLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .right
    label.font = Style.Arrow.textFont
    label.textColor = Style.Arrow.textColor
    label.text = Style.Arrow.text
    label.numberOfLines = 0
    return label
  }()
  lazy var lightStack: UIStackView = {
    let stack = UIStackView(arrangedSubviews: [lightImage, lightLabel])
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.alignment = .center
    stack.spacing = Style.Light.space
    return stack
  }()
  lazy var lightImage: UIImageView = {
    let view = UIImageView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.contentMode = .scaleAspectFit
    view.image = Style.Light.image
    return view
  }()
  lazy var lightLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.adjustsFontSizeToFitWidth = true
    label.font = Style.Light.textFont
    label.textColor = Style.Light.textColor
    label.text = Style.Light.text
    return label
  }()

}
