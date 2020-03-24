//
//  HomeViewModel.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/15.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol HomeViewModelInputs {
  /// coredata -> memo 가져옴
  func getMemo()
  func deleteMemo(identifier: UUID?)
  func flushData()
}
protocol HomeViewModelOutputs {
  /// memo
  var memos: BehaviorRelay<[MemoData]> {get}
  /// popup data
  var popupData: [MemoEdit] {get}
}
protocol HomeViewModelType {
  var inputs: HomeViewModelInputs {get}
  var outputs: HomeViewModelOutputs {get}
}

class HomeViewModel: HomeViewModelInputs, HomeViewModelOutputs, HomeViewModelType {
  
  private let disposeBag = DisposeBag()
  
  var popupData = [
    Constant.BottomPopup.MemoOrderType.title,
    Constant.BottomPopup.MemoOrderType.createDate,
    Constant.BottomPopup.MemoOrderType.modifyDate
  ]
  
  let coreData: CoreDataModelType
  init(coreData: CoreDataModelType) {
    self.coreData = coreData
    coreData.outputs.memos.subscribe(onNext: { (data) in
      self.memos.accept(data)
    }).disposed(by: disposeBag)
  }
  func getMemo() {
    self.coreData.inputs.getMemos()
  }
  func deleteMemo(identifier: UUID?) {
    if let data = identifier {
    let _ = self.coreData.inputs.delete(identifier: data)
    } else {
      //error처리
    }
  }
  
  func flushData() {
    CoreDataManager.sharedManager.flushData()
    getMemo()
  }
  
  var memos: BehaviorRelay<[MemoData]> = BehaviorRelay(value: [])
  var inputs: HomeViewModelInputs { return self }
  var outputs: HomeViewModelOutputs { return self }
}
