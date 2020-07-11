//
//  UIApplication+.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/05/09.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

// disabled this code for automatic dark mode
//extension UIApplication {
//  
//  enum ColorMode {
//    case dark, light, customColorLowerThanIOS13(_ color: UIColor)
//  }
//  
//  func setStatusBarTextColor(_ mode: ColorMode) {
//    if #available(iOS 13.0, *) {
//      guard let appDelegate = delegate as? AppDelegate else { return }
//      
//      var style: UIUserInterfaceStyle
//      
//      switch mode {
//      case .dark:
//        style = .dark
//      default:
//        style = .light
//      }
//      
//      appDelegate.window?.overrideUserInterfaceStyle = style
//    } else {
//      if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
//        var color: UIColor
//        
//        switch mode {
//        case .dark:
//          color = .white
//        case .light:
//          color = .black
//        case .customColorLowerThanIOS13(let customColor):
//          color = customColor
//        }
//        
//        statusBar.setValue(color, forKey: "foregroundColor")
//      }
//    }
//  }
//  
//}
