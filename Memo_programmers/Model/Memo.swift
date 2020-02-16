//
//  Memo.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/15.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

// 데이터 모델 (앱에서 사용) => || => coredata

public struct MemoData {
  
  let title: String?
  let memo: String?
  let date: Date?
  let identifier: UUID?
  var imageArray: [UIImage]?
  
}

extension MemoData {
  public init() {
    title = ""
    memo = ""
    date = Date()
    identifier = UUID()
    imageArray = []
  }
}
