//
//  enumTypes.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/24.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

/**
order Type Popup Type
*/
enum OrderType: String {
  case title
  case createDate
  case modifyDate
}

/**
 color theme
 */
enum ColorTheme: String {
  case light
  case dark
}

/**
 URL 로 이미지를 로드하는 Navigation Type
 - load: 이미지 로드 상태
 - save: load 성공 시 저장 상태로
 */
enum ImageURLType {
  case load
  case save
}

/**
 현재 메모뷰의 Type
 - Edit: 기존 메모 편집
 - Add: 메모 추가
 - Read: 기존 메모 열람
 */
enum MemoDetailType {
  case edit
  case add
  case read
}
