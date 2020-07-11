//
//  shdow.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/15.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
// swiftlint:disable all
struct Shadow {
  let color: UIColor
  let alpha: Float
  let x: CGFloat
  let y: CGFloat
  let blur: CGFloat
}

extension CALayer {
  func shadow(
    color: UIColor = .black,
    alpha: Float = 0.5,
    x: CGFloat = 0,
    y: CGFloat = 2,
    blur: CGFloat = 4,
    spread: CGFloat = 0) {
    shadowColor = color.cgColor
    shadowOpacity = alpha
    shadowOffset = CGSize(width: x, height: y)
    shadowRadius = blur / 2.0
    if spread == 0 {
      shadowPath = nil
    } else {
      let dx = -spread
      let rect = bounds.insetBy(dx: dx, dy: dx)
      shadowPath = UIBezierPath(rect: rect).cgPath
    }
  }
  func shadow(
    shadow: Shadow) {
    shadowColor = shadow.color.cgColor
    shadowOpacity = shadow.alpha
    shadowOffset = CGSize(width: shadow.x, height: shadow.y)
    shadowRadius = shadow.blur / 2.0
  }
}
// swiftlint:enable all
