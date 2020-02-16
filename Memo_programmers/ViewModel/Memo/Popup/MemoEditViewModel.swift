//
//  MemoEditViewModel.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/16.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


protocol MemoEditViewModelInputs {
  func setCurrentType(type: MemoBottomType)
}

protocol MemoEditViewModelOutputs {
  var memoEditData: Observable<[MemoEdit]> {get}
}

protocol MemoEditViewModelType {
  var inputs: MemoEditViewModelInputs {get}
  var outputs: MemoEditViewModelOutputs {get}
}

class MemoEditViewModel: MemoEditViewModelInputs, MemoEditViewModelOutputs, MemoEditViewModelType {
  var memoEditData: Observable<[MemoEdit]>
  
  
  init() {
    self.memoEditData = PublishSubject()
  }
  
  func setCurrentType(type: MemoBottomType) {
    switch type {
    case .editMemo:
      self.memoEditData = Observable<[MemoEdit]>.of([
        MemoEdit(iconSysName: "pencil", title: "편집"),
        MemoEdit(iconSysName: "trash", title: "삭제")
      ])

    default:
      self.memoEditData = Observable<[MemoEdit]>.of([
        MemoEdit(iconSysName: "pencil", title: "사진 불러오기"),
        MemoEdit(iconSysName: "pencil", title: "카메라로 찍기"),
        MemoEdit(iconSysName: "trash", title: "URL 로 입력하기")
      ])
    }
  }
  
  var inputs: MemoEditViewModelInputs {return self}
  var outputs: MemoEditViewModelOutputs {return self}
  
  
}
