//
//  CoreDataManager.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/23.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//
import Foundation
import CoreData

import Foundation
import CoreData
import UIKit

class CoreDataManager {
  
  //1
  static let sharedManager = CoreDataManager()
  private init() {} // Prevent clients from creating another instance.
  
  //2
  lazy var persistentContainer: NSPersistentContainer = {
    
    let container = NSPersistentContainer(name: "Memo_programmers")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  //3
  func saveContext () {
    let context = CoreDataManager.sharedManager.persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  /*Insert*/
  func add(newMemo: MemoData) -> (Bool, Error?){
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    
    
    var coredataTypeArr: [Images] = []
    for i in newMemo.imageArray ?? [] {
      let image = (NSEntityDescription.insertNewObject(forEntityName: "Images", into: managedContext) as! Images)
      image.identifier = i.image.jpegData(compressionQuality: 0.8)!
      image.date = i.date
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
    } catch let error as NSError {
      print("Could not save. \(error), \(error.userInfo)")
      return (false, error)
    }
  }
  
  /*delete*/
  func delete(identifier: UUID) -> (Bool, Error?) {

    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
    fetchRequest.returnsObjectsAsFaults = false
    let predicate = NSPredicate(format: "identifier == %@", identifier as CVarArg)
    fetchRequest.predicate = predicate

    do {
      
      let fetchResults: Array = try managedContext.fetch(fetchRequest)
      
      for fetchResult in fetchResults {
        let managedObject = fetchResult as! NSManagedObject
        
        managedContext.delete(managedObject)
      }
      } catch let error as NSError {
      print(error)
      return (false, error)
    }
    
    do {
      try managedContext.save()
      return (true, nil)
      } catch let error as NSError {
      return (false, error)
    }
  }
  
  func update(updateMemo: MemoData) -> (Bool, Error?){
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
    fetchRequest.returnsObjectsAsFaults = false
    let predicate = NSPredicate(format: "identifier == %@", updateMemo.identifier! as CVarArg)
    fetchRequest.predicate = predicate
    fetchRequest.fetchLimit = 1
    var coredataTypeArr: [Images] = []
    for i in updateMemo.imageArray ?? [] {
      let image = (NSEntityDescription.insertNewObject(forEntityName: "Images", into: managedContext) as! Images)
      image.identifier = i.image.jpegData(compressionQuality: 0.8)!
      image.date = i.date
      coredataTypeArr.append(image)
    }
    do {
      let fetchResult = try managedContext.fetch(fetchRequest).first
      let managedObject = fetchResult as! NSManagedObject
      managedObject.setValue(updateMemo.title, forKey: "title")
      managedObject.setValue(updateMemo.memo, forKey: "memo")
      managedObject.setValue(updateMemo.date, forKey: "date")
      managedObject.setValue(updateMemo.modifyDate, forKey: "modifyDate")
      managedObject.setValue(NSSet(array: coredataTypeArr), forKey: "images")
      do {
        try managedContext.save()
        return (true, nil)
        } catch let error as NSError {
        return (false, error)
      }
      } catch let error as NSError {
      return (false, error)
    }
  }

  func fetchAllMemos() -> [Memo]?{
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    let fetchRequest2 = NSFetchRequest<Memo>(entityName: "Memo")
    // unit test check
    if NSClassFromString("XCTest") != nil {
      fetchRequest2.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    } else {
    if let orderType = userPreferences.getOrderType() {
      if orderType == "title" {
        fetchRequest2.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare))]
      } else if orderType == "modifyDate" {
        fetchRequest2.sortDescriptors = [NSSortDescriptor(key: "modifyDate", ascending: false)]
      } else {
        fetchRequest2.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
      }
    } else {
      userPreferences.setOrderType(type: "createDate")
      fetchRequest2.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    }
    }
        
//    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
    
    do {
      let memos = try managedContext.fetch(fetchRequest2)
      return memos
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
      return nil
    }
  }

  
  func flushData() {
    
    let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
    let objs = try! CoreDataManager.sharedManager.persistentContainer.viewContext.fetch(fetchRequest)
    for case let obj as NSManagedObject in objs {
      CoreDataManager.sharedManager.persistentContainer.viewContext.delete(obj)
    }
    
    try! CoreDataManager.sharedManager.persistentContainer.viewContext.save()
  }
}