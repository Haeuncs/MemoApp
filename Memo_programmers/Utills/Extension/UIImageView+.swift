//
//  UIImageView+.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/05/09.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

// reference: https://stackoverflow.com/questions/30014241/uiimageview-pinch-zoom-swift

import UIKit

extension UIImageView {
  func enableZoom() {
    let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(startZooming(_:)))
    isUserInteractionEnabled = true
    addGestureRecognizer(pinchGesture)
  }
  
  @objc
  private func startZooming(_ sender: UIPinchGestureRecognizer) {
    let scaleResult = sender.view?.transform.scaledBy(x: sender.scale, y: sender.scale)
    guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
    sender.view?.transform = scale
    sender.scale = 1
  }
  
  func initZoom() {
    self.transform = .identity
  }
}
