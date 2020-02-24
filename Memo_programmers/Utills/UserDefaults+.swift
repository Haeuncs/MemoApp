//
//  UserDefaults+.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/22.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation

let userPreferences = UserDefaults.standard

extension UserDefaults {
  /**
   return Type
   1. "title"
   2. "createDate"
   3. "modifyDate"
   */
  private var orderType: String {
    return "orderType"
  }
  func getOrderType() -> String? {
    return userPreferences.string(forKey: orderType)
  }
  func getOrderTypeKor() -> String? {
    guard let type = userPreferences.string(forKey: orderType) else {
      return nil
    }
    if type == "title" {
      return Constant.BottomPopup.MemoOrderType.title.title
    } else if type == "createDate" {
      return Constant.BottomPopup.MemoOrderType.createDate.title
    } else {
      return Constant.BottomPopup.MemoOrderType.modifyDate.title
    }
  }
  func setOrderType(type: String) {
    userPreferences.set(type, forKey: orderType)
  }
  
  /**
   
   */
  private var colorTheme: String {
    return "colorTheme"
  }
  func getColorTheme() -> String {
    if let theme = userPreferences.string(forKey: colorTheme) {
      return theme
    } else {
      setColorTheme(theme: "light")
      return "light"
    }
  }
  /**
   - Parameters:
   - theme: 컬러 테마 `light`, `dark`
   */
  func setColorTheme(theme: String) {
    userPreferences.set(theme, forKey: colorTheme)
  }
}
