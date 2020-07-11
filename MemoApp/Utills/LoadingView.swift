//
//  LoadingView.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/23.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

class LoadingView: NSObject {
  private static let shared = LoadingView()
  private var backView: UIView?
  private var spinner: UIActivityIndicatorView?

  private override init() { }

  static func show() {
    let backView = UIView(frame: .zero)
    backView.backgroundColor = Color.dim
    let popupView = UIActivityIndicatorView.init(style: .whiteLarge)

    if let window = UIApplication.shared.keyWindow {
      window.addSubview(backView)
      backView.frame = window.frame
      backView.addSubview(popupView)
      popupView.center = backView.center
      DispatchQueue.main.async {
        popupView.startAnimating()
      }
      shared.backView?.removeFromSuperview()
      shared.backView = backView
      shared.spinner?.removeFromSuperview()
      shared.spinner = popupView
    }
  }

  static func hide() {
    if let popupView = shared.spinner, let backView = shared.backView {
      DispatchQueue.main.async {
        popupView.stopAnimating()
        popupView.removeFromSuperview()
        backView.removeFromSuperview()
      }
    }
  }
  static func showActivityIndicator(view: UIView, targetVC: UIViewController) {

    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    activityIndicator.backgroundColor = UIColor(red: 0.16, green: 0.17, blue: 0.21, alpha: 1)
    activityIndicator.layer.cornerRadius = 6
    activityIndicator.center = targetVC.view.center
    activityIndicator.hidesWhenStopped = true
    activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
    activityIndicator.tag = 1
    view.addSubview(activityIndicator)
    activityIndicator.startAnimating()
    UIApplication.shared.beginIgnoringInteractionEvents()
  }

  static func hideActivityIndicator(view: UIView) {
    let activityIndicator = view.viewWithTag(1) as? UIActivityIndicatorView
    activityIndicator?.stopAnimating()
    activityIndicator?.removeFromSuperview()
    UIApplication.shared.endIgnoringInteractionEvents()
  }

}
