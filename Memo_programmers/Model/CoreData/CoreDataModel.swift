//
//  CoreDataModel.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/15.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

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
  var outputs: CoreDataModelOutputs{return self}
  
  var memos: PublishSubject<[MemoData]>
  
  private var entityName = "Memo"
  
  init() {
    self.memos = PublishSubject()
  }
  
  /// coredata에서 memo 저장된 순서로 fetch
  func getMemos() {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    let fetchRequest2 = NSFetchRequest<Memo>(entityName: entityName)
    fetchRequest2.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    var fetchMemoDataArray: [MemoData] = []
    if let result = try? managedContext.fetch(fetchRequest2) {
      for data in result {
        var uiImageArr: [UIImage] = []
        if let imageData = data.images?.value(forKey: "identifier") as? Set<Data>{
          for i in Array(imageData) {
            uiImageArr.append(UIImage.init(data: i)!)
          }
        }
        let tempData: MemoData = MemoData(title: data.title,
                                          memo: data.memo,
                                          date: data.date,
                                          identifier: data.identifier,
                                          imageArray: uiImageArr)
        fetchMemoDataArray.append(tempData)
      }
    }
    self.memos.onNext(fetchMemoDataArray)
  }
  func add(newMemo: MemoData) -> (Bool, Error?){
    
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

    var coredataTypeArr: [Images] = []
    for i in newMemo.imageArray ?? [] {
      let image = (NSEntityDescription.insertNewObject(forEntityName: "Images", into: managedContext) as! Images)
      image.identifier = i.pngData()!
      coredataTypeArr.append(image)
    }

    let memo = Memo(context: managedContext)
    memo.title = newMemo.title
    memo.memo = newMemo.memo
    memo.date = newMemo.date
    memo.identifier = newMemo.identifier
    memo.images = NSSet(array: coredataTypeArr)
    do {
      try managedContext.save()
      return (true, nil)
    }catch let error {
      return (false, error)
    }
  }
  
  /// identifier 로 메모 찾아 삭제
  func delete(identifier: UUID) -> (Bool, Error?) {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    fetchRequest.returnsObjectsAsFaults = false
    let predicate = NSPredicate(format: "identifier == %@", identifier as CVarArg)
    fetchRequest.predicate = predicate
    
    do {
      let fetchResults: Array = try managedContext.fetch(fetchRequest)
      
      for fetchResult in fetchResults {
        let managedObject = fetchResult as! NSManagedObject
        
        managedContext.delete(managedObject)
      }
      try managedContext.save()
      return (true, nil)
//      self.fetchDiaries()
    }catch let error {
      return (false, error)
//      self.error.onNext(error.localizedDescription)
    }
  }
  
  
  func update(updateMemo: MemoData) -> (Bool, Error?){
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedContext: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
    managedContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
    fetchRequest.returnsObjectsAsFaults = false
    let predicate = NSPredicate(format: "identifier == %@", updateMemo.identifier! as CVarArg)
    fetchRequest.predicate = predicate
    fetchRequest.fetchLimit = 1
    
    do {
      //検索実行
      let fetchResult = try managedContext.fetch(fetchRequest).first
      let managedObject = fetchResult as! NSManagedObject
      managedObject.setValue(updateMemo.title, forKey: "title")
      managedObject.setValue(updateMemo.memo, forKey: "memo")
      managedObject.setValue(updateMemo.date, forKey: "date")
      try managedContext.save()
        return (true, nil)
    }catch let error {
      NSLog("\(error)")
      return (false, error)
    }
    
  }
  
}
