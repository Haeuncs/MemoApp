//
//  NeomorphismButton.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/22.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import SnapKit

class NeomorphismButton: UIButton {
  
//  weak var delegate: WeatherDataButtonDelegate?
  var isSelectedMode: Bool?
  
  override open var isHighlighted: Bool {
    didSet {
      if isSelectedMode == nil {
        if isHighlighted {
          highlightState()
//          delegate?.buttonDidTap()
        } else {
          defaultState()
//          delegate?.buttonDidRelease()
        }
      }
    }
  }
  override var isSelected: Bool {
    didSet{
      if isSelected {
        highlightState()
      }else {
        defaultState()
      }
    }
  }
  var customLightShadow: Shadow? {
    didSet {
      setLightShadow(shadow: customLightShadow!)
    }
  }
  var customDarkShadow: Shadow? {
    didSet {
      setDarkShadow(shadow: customDarkShadow!)
    }
  }
  
  func setLightShadow(shadow: Shadow) {
    self.lightView.layer.shadow(color: shadow.color, alpha: shadow.alpha, x: shadow.x, y: shadow.y, blur: shadow.blur, spread: 0)
  }
  func setDarkShadow(shadow: Shadow) {
    self.darkView.layer.shadow(color: shadow.color, alpha: shadow.alpha, x: shadow.x, y: shadow.y, blur: shadow.blur, spread: 0)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.backgroundColor = Constant.UI.backgroundColor
    
    self.addSubview(lightView)
    self.addSubview(darkView)
    lightView.snp.makeConstraints { (make) in
      make.top.leading.trailing.bottom.equalTo(self)
    }
    darkView.snp.makeConstraints { (make) in
      make.top.leading.trailing.bottom.equalTo(self)
    }
    
    defaultState()
  }
  
  func setBackgroundColor(color: UIColor){
    self.backgroundColor = color
    self.lightView.backgroundColor = color
    self.darkView.backgroundColor = color
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func setCornerRadius(radius: CGFloat){
    self.layer.cornerRadius = radius
    lightView.layer.cornerRadius = radius
    darkView.layer.cornerRadius = radius
  }
  
  func defaultState(){
    if let shadow = customLightShadow, let darkShadow = customDarkShadow {
      self.darkView.layer.shadow(color: darkShadow.color, alpha: darkShadow.alpha, x: darkShadow.x, y: darkShadow.y, blur: darkShadow.blur, spread: 0)
      self.lightView.layer.shadow(color: shadow.color, alpha: shadow.alpha, x: shadow.x, y: shadow.y, blur: shadow.blur, spread: 0)
    }else{
      darkView.layer.shadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.28, x: 2, y: 2, blur: 2, spread: 0)
      lightView.layer.shadow(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), alpha: 0.65, x: -3, y: -3, blur: 2, spread: 0)
    }
    //    UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
    //      self.lightView.transform = .identity
    //      self.darkView.transform = .identity
    //    }, completion: nil)
    
  }
  
  func highlightState(){
    if let darkShadow = customLightShadow, let shadow = customDarkShadow {
      self.darkView.layer.shadow(color: shadow.color, alpha: shadow.alpha, x: darkShadow.x, y: darkShadow.y, blur: darkShadow.blur, spread: 0)
      self.lightView.layer.shadow(color: darkShadow.color, alpha: darkShadow.alpha, x: shadow.x, y: shadow.y, blur: shadow.blur, spread: 0)
    }else{
      darkView.layer.shadow(color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), alpha: 0.65, x: 2, y: 2, blur: 2, spread: 0)
      lightView.layer.shadow(color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), alpha: 0.28, x: -3, y: -3, blur: 2, spread: 0)
    }
    
    //    UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
    //      self.lightView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98)
    //      self.darkView.transform = CGAffineTransform(scaleX: 0.98, y: 0.98 )
    //    }, completion: nil)
    
    
  }
  lazy var darkView: UIButton = {
    let view = UIButton()
    view.isUserInteractionEnabled = false
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  lazy var lightView: UIView = {
    let view = UIView()
    view.isUserInteractionEnabled = false
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
}
