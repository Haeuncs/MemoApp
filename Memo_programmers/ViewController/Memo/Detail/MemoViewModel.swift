//
//  MemoViewModel.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/16.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol MemoViewModelInputs {
  var title: BehaviorRelay<String> {get}
  var content: BehaviorRelay<String> {get}
  var imageArray: BehaviorRelay<[Image]> {get}
  func add() -> Bool
  func update() -> Bool
  func delete() -> Bool
}

protocol MemoViewModelOutputs {
  var memoEditData: [MemoEdit] {get}
  var memoAddImage: [MemoEdit] {get}
  var error: PublishSubject<String> {get}
  var memo: BehaviorRelay<MemoData> {get}
}

protocol MemoViewModelType {
  var inputs: MemoViewModelInputs {get}
  var outputs: MemoViewModelOutputs {get}
}

class MemoViewModel: MemoViewModelInputs, MemoViewModelOutputs, MemoViewModelType {

  // MARK: - Inputs
  var title: BehaviorRelay<String>
  var content: BehaviorRelay<String>
  var imageArray: BehaviorRelay<[Image]>

  // MARK: - Outputs
  let memo: BehaviorRelay<MemoData>
  var error = PublishSubject<String>()
  var memoEditData: [MemoEdit] = [
    Constant.BottomPopup.MemoEditType.edit,
    Constant.BottomPopup.MemoEditType.delete
  ]
  var memoAddImage: [MemoEdit] = [
    Constant.BottomPopup.MemoAddPhotoType.loadByGallery,
    Constant.BottomPopup.MemoAddPhotoType.loadByCamera,
    Constant.BottomPopup.MemoAddPhotoType.loadByURL
  ]

  // MARK: - Init
  let coreData: CoreDataModelType
  init(coreData: CoreDataModelType, memo: MemoData?) {
    self.coreData = coreData
    if let memoData = memo {
      self.memo = BehaviorRelay(value: (memoData))
      self.title = BehaviorRelay(value: memoData.title ?? "")
      self.content = BehaviorRelay(value: memoData.memo ?? "")
      self.imageArray = BehaviorRelay(value: memoData.imageArray ?? [])
    } else {
      self.memo = BehaviorRelay(value: (MemoData()))
      self.title = BehaviorRelay(value: "")
      self.content = BehaviorRelay(value: "")
      self.imageArray = BehaviorRelay(value: [])
    }
  }

  func add() -> Bool {
    let (bool, _) = coreData.inputs.add(newMemo:
      MemoData(title: self.title.value,
               memo: self.content.value,
               date: self.memo.value.date,
               identifier: self.memo.value.identifier,
               imageArray: self.imageArray.value))
    if !bool {
      self.error.onNext("저장 실패")
    } else {
      self.error.onNext("메모가 추가되었어요.")
    }
    return bool
  }

  func update() -> Bool {
    let memoData =  MemoData(title: self.title.value,
                             memo: self.content.value,
                             date: self.memo.value.date,
                             modifyDate: Date(),
                             identifier: self.memo.value.identifier,
                             imageArray: self.imageArray.value)
    let (bool, _) = self.coreData.inputs.update(updateMemo: memoData)
    if !bool {
      self.error.onNext("업데이트 실패")
    } else {
      self.error.onNext("메모가 수정되었습니다.")
    }
    return bool
  }

  func delete() -> Bool {
    let (bool, _) = coreData.inputs.delete(identifier: self.memo.value.identifier!)
    if !bool {
      self.error.onNext("삭제 실패")
    } else {
      self.error.onNext("메모가 삭제되었습니다.")
    }
    return bool
  }

  var inputs: MemoViewModelInputs {return self}
  var outputs: MemoViewModelOutputs {return self}

}
