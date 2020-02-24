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
  /// 제목
  var title: BehaviorRelay<String> {get}
  /// 본문
  var content: BehaviorRelay<String> {get}
  /// 이미지들
  var imageArray: BehaviorRelay<[Image]> {get}
  func add() -> Bool
  func update() -> Bool
  func delete() -> Bool
}

protocol MemoViewModelOutputs {
  /// popup 에서 그리는 데이터
  var memoEditData: [MemoEdit] {get}
  /// popup 에서 그리는 데이터
  var memoAddImage: [MemoEdit] {get}
  var error: PublishSubject<String> {get}
}

protocol MemoViewModelType {
  var inputs: MemoViewModelInputs {get}
  var outputs: MemoViewModelOutputs {get}
}
class MemoViewModel: MemoViewModelInputs, MemoViewModelOutputs, MemoViewModelType {
  var error = PublishSubject<String>()
  var title: BehaviorRelay<String>
  var content: BehaviorRelay<String>
  var imageArray: BehaviorRelay<[Image]>
  
  var memoEditData: [MemoEdit] = [
    Constant.BottomPopup.MemoEditType.edit,
    Constant.BottomPopup.MemoEditType.delete
  ]
  var memoAddImage: [MemoEdit] = [
    Constant.BottomPopup.MemoAddPhotoType.loadByGallery,
    Constant.BottomPopup.MemoAddPhotoType.loadByCamera,
    Constant.BottomPopup.MemoAddPhotoType.loadByURL
  ]
  
  let memo: MemoData
  let coreData: CoreDataModelType
  init(coreData: CoreDataModelType, memo: MemoData?) {
    self.coreData = coreData
    if memo == nil {
      self.memo = MemoData()
      self.title = BehaviorRelay(value: "")
      self.content = BehaviorRelay(value: "")
      self.imageArray = BehaviorRelay(value: [])
    }else {
      self.memo = memo!
      self.title = BehaviorRelay(value: memo!.title ?? "")
      self.content = BehaviorRelay(value: memo!.memo ?? "")
      self.imageArray = BehaviorRelay(value: memo!.imageArray ?? [])
    }
  }
  func add() -> Bool{
    let (bool, _) = coreData.inputs.add(newMemo:
      MemoData(title: self.title.value,
               memo: self.content.value,
               date: self.memo.date,
               identifier: self.memo.identifier,
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
                             date: self.memo.date,
                             modifyDate: Date(),
                             identifier: self.memo.identifier,
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
    let (bool, _) = coreData.inputs.delete(identifier: self.memo.identifier!)
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
