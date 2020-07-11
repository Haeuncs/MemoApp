//
//  HomeViewModel.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/15.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol HomeViewModelInputs {
  func getMemo()
  func deleteMemo(identifier: UUID?)
  func flushData()
}

protocol HomeViewModelOutputs {
  var memos: BehaviorRelay<[MemoData]> {get}
}

protocol HomeViewModelType {
  var inputs: HomeViewModelInputs {get}
  var outputs: HomeViewModelOutputs {get}
}

class HomeViewModel: HomeViewModelInputs, HomeViewModelOutputs, HomeViewModelType {

  // MARK: - Private
  private let disposeBag = DisposeBag()

  let coreData: CoreDataModelType

  // MARK: - Init
  init(coreData: CoreDataModelType) {
    self.coreData = coreData
    coreData.outputs.memos.subscribe(onNext: { (data) in
      self.memos.accept(data)
    }).disposed(by: disposeBag)
  }

  // MARK: - Inputs
  func getMemo() {
    self.coreData.inputs.getMemos()
  }

  func deleteMemo(identifier: UUID?) {
    if let data = identifier {
      _ = self.coreData.inputs.delete(identifier: data)
    } else {
      //error처리
    }
  }

  func flushData() {
    CoreDataManager.sharedManager.flushData()
    getMemo()
  }

  // MARK: - Outputs
  var memos: BehaviorRelay<[MemoData]> = BehaviorRelay(value: [])

  var inputs: HomeViewModelInputs { return self }
  var outputs: HomeViewModelOutputs { return self }
}
