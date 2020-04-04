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
  func getOrderType() -> OrderType {
    if let type = userPreferences.string(forKey: orderType) {
      return OrderType(rawValue: type) ?? OrderType.createDate
    } else {
      return .createDate
    }
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
  func setOrderType(type: OrderType) {
    userPreferences.set(type.rawValue, forKey: orderType)
  }

  /**
   
   */
  private var colorTheme: String {
    return "colorTheme"
  }
  func getColorTheme() -> ColorTheme {
    if let theme = userPreferences.string(forKey: colorTheme) {
      return theme == ColorTheme.light.rawValue ? .light : .dark
    } else {
      setColorTheme(theme: .light)
      return .light
    }
  }
  /**
   - Parameters:
   - theme: 컬러 테마 `light`, `dark`
   */
  func setColorTheme(theme: ColorTheme) {
    userPreferences.set(theme.rawValue, forKey: colorTheme)
  }

  private var tutorial: String {
    return "openTutorial"
  }
  func getisOpenTutorial() -> Bool {
    return userPreferences.bool(forKey: tutorial)
  }
  func setOpenTutorial(bool: Bool) {
    userPreferences.set(bool, forKey: tutorial)
  }
}
