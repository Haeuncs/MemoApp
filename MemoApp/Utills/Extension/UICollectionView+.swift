//
//  UICollectionView+.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/22.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

extension UICollectionView {
  func setHomeEmptyBackgroundView() {
    let view = HomeEmptyMemoView()
//    view.translatesAutoresizingMaskIntoConstraints = false
    view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    self.backgroundView = view
  }
  func restore() {
    self.backgroundView = nil
  }

}
