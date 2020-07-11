//
//  CoreDataModel.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/15.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

/**
 코어 데이터 조작하는 모델
 save, update, add, load
 */

import UIKit
import CoreData
import RxSwift

protocol CoreDataModelInputs {
  func getMemos()
  func add(newMemo: MemoData) -> (Bool, Error?)
  func delete(identifier: UUID) -> (Bool, Error?)
  func update(updateMemo: MemoData) -> (Bool, Error?)
}

protocol CoreDataModelOutputs {
  var memos: PublishSubject<[MemoData]> {get}
}

protocol CoreDataModelType {
  var inputs: CoreDataModelInputs { get }
  var outputs: CoreDataModelOutputs { get }
}

class CoreDataModel: CoreDataModelInputs, CoreDataModelOutputs, CoreDataModelType {

  var inputs: CoreDataModelInputs {return self}
  var outputs: CoreDataModelOutputs {return self}

  var memos: PublishSubject<[MemoData]>

  private var entityName = "Memo"

  init() {
    self.memos = PublishSubject()
  }

  /// coredata에서 memo 저장된 순서로 fetch
  func getMemos() {

    var fetchMemoDataArray: [MemoData] = []
    if let result = CoreDataManager.sharedManager.fetchAllMemos() {
      for data in result {
        var uiImageArr: [Image] = []
        if let imageData = data.images as? Set<Images> {
          // image sorted by Date
          let sortedImageByDate = imageData.sorted { (image1, image2) -> Bool in
            return image1.date! < image2.date!
          }
          for image in sortedImageByDate {
            var structImage = Image()
            structImage.date = image.date ?? Date()
            if let imageIdentifier = image.identifier {
              structImage.image = UIImage.init(data: imageIdentifier) ?? UIImage()
            }
            uiImageArr.append(structImage)
          }
        }

        let tempData: MemoData = MemoData(title: data.title,
                                          memo: data.memo,
                                          date: data.date,
                                          modifyDate: data.modifyDate,
                                          identifier: data.identifier,
                                          imageArray: uiImageArr)
        fetchMemoDataArray.append(tempData)
      }
    }
    self.memos.onNext(fetchMemoDataArray)
  }
  func add(newMemo: MemoData) -> (Bool, Error?) {
    return CoreDataManager.sharedManager.add(newMemo: newMemo)
  }

  /// identifier 로 메모 찾아 삭제
  func delete(identifier: UUID) -> (Bool, Error?) {
    return CoreDataManager.sharedManager.delete(identifier: identifier)
  }

  func update(updateMemo: MemoData) -> (Bool, Error?) {
    return CoreDataManager.sharedManager.update(updateMemo: updateMemo)
  }

}
