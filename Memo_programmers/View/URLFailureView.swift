//
//  URLFailureView.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/22.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//


import UIKit
import SnapKit

private enum Style {
  enum Light {
    static let space: CGFloat = 20
    static let image: UIImage = UIImage(named: "warningImage")!
    static let text: String = "앗! 이미지를 가져올 수 없습니다."
    static let textColor: UIColor = Color.grey
    static let textFont: UIFont = .sb14
  }
}
class URLFailureView: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    initView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  // MARK: - InitView
  func initView() {
    self.addSubview(lightStack)
    lightStack.snp.makeConstraints { (make) in
      make.centerX.equalTo(self)
      make.centerY.equalTo(self)
      make.leading.trailing.lessThanOrEqualTo(self)
    }
  }
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

