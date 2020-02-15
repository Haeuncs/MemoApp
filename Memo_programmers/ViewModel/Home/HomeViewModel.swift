//
//  HomeViewModel.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/15.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import Foundation
import RxSwift

protocol HomeViewModelInputs {
  func getMemo()
}

protocol HomeViewModelOutputs {
  var memos: PublishSubject<[MemoData]> {get}
}

protocol HomeViewModelProtocol {
  var inputs: HomeViewModelInputs {get}
  var outputs: HomeViewModelOutputs {get}
}

class HomeViewModel: HomeViewModelInputs, HomeViewModelOutputs, HomeViewModelProtocol {
  
  private let disposeBag = DisposeBag()
  
  let coreData: CoreDataModelType
  init(coreData: CoreDataModelType) {
    self.coreData = coreData
    coreData.outputs.memos.subscribe(onNext: { (data) in
      self.memos.onNext(data)
    }).disposed(by: disposeBag)
  }
  func getMemo() {
    self.coreData.inputs.getMemos()
  }
  
  var memos: PublishSubject<[MemoData]> = PublishSubject()
  var inputs: HomeViewModelInputs { return self }
  var outputs: HomeViewModelOutputs { return self }
}
