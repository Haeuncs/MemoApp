//
//  CellType.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/23.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit

enum BottomCellStyle {
  case selected
  case `default`
}

struct BottomCellData {

  private(set) var cellData: MemoEdit
  private(set) var style = BottomCellStyle.default
  private(set) var handler: (() -> Void)

  init(cellData: MemoEdit,
       style: BottomCellStyle = BottomCellStyle.default,
       handler: @escaping (() -> Void)) {
    self.cellData = cellData
    self.style = style
    self.handler = handler
  }
}
