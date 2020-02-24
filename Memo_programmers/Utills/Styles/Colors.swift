//
//  Colors.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/11.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

struct Color {
  static var dim = UIColor()
  static var background = UIColor()
  static var black = UIColor()
  static var grey = UIColor()
  static var veryLightGrey = UIColor()
  static var selectionColor = UIColor()
  static var selectedColor = UIColor()
}

class Theme {
  static func darkMode() {
    Color.dim = UIColor.white.withAlphaComponent(0.11)
    Color.background = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
    Color.black = .white
    Color.grey = UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1)
    Color.veryLightGrey = UIColor(white: 227.0 / 255.0, alpha: 1.0)
    Color.selectionColor = #colorLiteral(red: 0.8510541524, green: 0.8692765832, blue: 0.9237902164, alpha: 0.6231538955)
    Color.selectedColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
  }
  static func lightMode() {
    Color.dim = UIColor.black.withAlphaComponent(0.11)
    Color.background = .white
    Color.black = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
    Color.grey = UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1)
    Color.veryLightGrey = UIColor(white: 227.0 / 255.0, alpha: 1.0)
    Color.selectionColor = #colorLiteral(red: 0.8510541524, green: 0.8692765832, blue: 0.9237902164, alpha: 0.6231538955)
    Color.selectedColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
  }
}
//extension UIColor {
//  public static var memo_black: UIColor {
//    return UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1)
//  }
//
//  public static var memo_grey: UIColor {
//    return UIColor(red: 105/255, green: 105/255, blue: 105/255, alpha: 1)
//  }
//  public static var memo_very_light_grey: UIColor {
//    return UIColor(white: 227.0 / 255.0, alpha: 1.0)
//  }
//  public static var memo_selectionColor: UIColor {
//    return #colorLiteral(red: 0.8510541524, green: 0.8692765832, blue: 0.9237902164, alpha: 0.6231538955)
//  }
//  public static var memo_selectedColor: UIColor {
//    return #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
//  }
//}
