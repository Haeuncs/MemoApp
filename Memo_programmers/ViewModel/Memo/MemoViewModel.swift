//
//  MemoViewModel.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/16.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation

protocol MemoViewModelInputs {
  func add(newMemo: MemoData) -> (Bool, Error?)
  func update(updateMemo: MemoData) -> (Bool, Error?)
  func delete(identifier: UUID) -> (Bool, Error?)
}

protocol MemoViewModelOutputs {
  var memoEditData: [MemoEdit] {get}
}

protocol MemoViewModelType {
  var inputs: MemoViewModelInputs {get}
  var outputs: MemoViewModelOutputs {get}
}
class MemoViewModel: MemoViewModelInputs, MemoViewModelOutputs, MemoViewModelType {  
  
  var memoEditData: [MemoEdit] = [
    MemoEdit(iconSysName: "pencil", title: "편집"),
    MemoEdit(iconSysName: "trash", title: "삭제")
  ]
  
  let coreData: CoreDataModelType
  init(coreData: CoreDataModelType) {
    self.coreData = coreData
  }
  func add(newMemo: MemoData) -> (Bool, Error?) {
    return coreData.inputs.add(newMemo: newMemo)
  }
  
  func update(updateMemo: MemoData) -> (Bool, Error?) {
    return coreData.inputs.update(updateMemo: updateMemo)
  }
  func delete(identifier: UUID) -> (Bool, Error?) {
    return coreData.inputs.delete(identifier: identifier)
  }

  var inputs: MemoViewModelInputs {return self}
  var outputs: MemoViewModelOutputs {return self}
  
  
}
