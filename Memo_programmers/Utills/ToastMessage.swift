//
//  ToastMessage.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/23.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//


import Foundation
import UIKit
import RxSwift
import RxCocoa
import SnapKit

enum ToastType {
  case warning
  case success
}
class ToastMessage: UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  public static func show(message: String, toastType: ToastType = .success){
    guard let window = UIApplication.shared.keyWindow else{
      fatalError("No access to UIApplication Window")
    }
    let alertHeight = CGFloat(54 + 50 + Constant.UI.safeInsetBottom_iOS10)
    
    let alert = ToastMessage(frame: CGRect(x: 0, y: window.frame.maxY + alertHeight , width: window.frame.width, height: alertHeight))
//    switch toastType {
//    case .success:
//      alert.contentView.setBackgroundColor(color: UIColor.온도컬러.어두운회색.withAlphaComponent(0.5))
//    case .warning:
//      alert.contentView.setBackgroundColor(color: UIColor.온도컬러.핑크.withAlphaComponent(0.5))
//    }
    alert.alpha = 0
    alert.setup()
    alert.titleLabel.text = message
    window.addSubview(alert)
    /// Animates the alert to show and disappear from the view
    UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut,.allowUserInteraction], animations: {
      alert.frame.origin.y = window.frame.maxY - alertHeight
      alert.alpha = 1.0
    }, completion: { _ in
      UIView.animate(withDuration: 0.4, delay: 1.8, options: [.curveEaseInOut,.allowUserInteraction], animations: {
        alert.frame.origin.y = window.frame.maxY + alertHeight
        alert.alpha = 0.0
      }, completion: { _ in
        alert.removeFromSuperview()
      })
    })
  }
  private func setup(){
    self.addSubview(contentView)
    contentView.addSubview(titleLabel)
    
    contentView.snp.makeConstraints { (make) in
      make.top.equalTo(self)
      make.leading.equalTo(self).offset(16)
      make.trailing.equalTo(self).offset(-16)
      make.bottom.equalTo(self.snp.bottom).offset(-50-Constant.UI.safeInsetBottom_iOS10)
    }
    titleLabel.snp.makeConstraints { (make) in
      make.center.equalTo(contentView)
      make.leading.trailing.lessThanOrEqualTo(contentView)
    }
  }
  
  lazy var contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = Constant.UI.radius
    view.backgroundColor = Color.black
    return view
  }()
  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textAlignment = .center
    label.numberOfLines = 0
    label.font = .sb14
    label.textColor = Color.background
    return label
  }()

}
