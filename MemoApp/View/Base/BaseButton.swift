//
//  BaseButton.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/21.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

/**
 기본 highlight 를 위한 UIButton
 */
class BaseButton: UIButton {
  override init(frame: CGRect) {
    super.init(frame: frame)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func setImage(_ image: UIImage?, for state: UIControl.State) {
    //    let renderImage = image?.withRenderingMode(.alwa)
    super.setImage(image, for: state)
  }

  override var isHighlighted: Bool {
    didSet {
      if isHighlighted {
        self.alpha = 0.8
      } else {
        self.alpha = 1
      }
    }
  }
}

