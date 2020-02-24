////
////  MemoEditViewModel.swift
////  Memo_programmers
////
////  Created by LEE HAEUN on 2020/02/16.
////  Copyright © 2020 LEE HAEUN. All rights reserved.
////
//
//import UIKit
//import RxSwift
//import RxCocoa
//
//
//protocol MemoEditViewModelInputs {
//  func setCurrentType(type: MemoBottomType)
//}
//
//protocol MemoEditViewModelOutputs {
//  var memoEditData: Observable<[MemoEdit]> {get}
//}
//
//protocol MemoEditViewModelType {
//  var inputs: MemoEditViewModelInputs {get}
//  var outputs: MemoEditViewModelOutputs {get}
//}
//
//class MemoEditViewModel: MemoEditViewModelInputs, MemoEditViewModelOutputs, MemoEditViewModelType {
//  var memoEditData: Observable<[MemoEdit]>
//  
//  init() {
//    self.memoEditData = PublishSubject()
//  }
//  
//  var inputs: MemoEditViewModelInputs {return self}
//  var outputs: MemoEditViewModelOutputs {return self}
//  
//  
//}
