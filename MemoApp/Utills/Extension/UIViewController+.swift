//
//  UIViewController+.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/12.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
  func setupHideKeyboardOnTap() {
    self.view.addGestureRecognizer(self.endEditingRecognizer())
    self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
  }

  /// Dismisses the keyboard from self.view
  private func endEditingRecognizer() -> UIGestureRecognizer {
    let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
    tap.cancelsTouchesInView = false
    return tap
  }
}
