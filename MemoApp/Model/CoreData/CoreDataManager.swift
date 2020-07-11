//
//  CoreDataManager.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/02/23.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//
import Foundation
import CoreData
import UIKit

class CoreDataManager: NSObject {

  static let sharedManager = CoreDataManager()

  override init() {
      super.init()
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(contextObjectDidChange(_:)),
      name: .NSManagedObjectContextObjectsDidChange,
      object: persistentContainer.viewContext
    )
  }

  lazy var persistentContainer: NSPersistentContainer = {

    let container = NSPersistentContainer(name: "MemoApp")
    container.loadPersistentStores(completionHandler: { (_, error) in

      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()

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

  // Insert
  func add(newMemo: MemoData) -> (Bool, Error?) {
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext

    var coredataTypeArr: [Images] = []
    for image in newMemo.imageArray ?? [] {
      if let imageData = (NSEntityDescription.insertNewObject(forEntityName: "Images",
                                                              into: managedContext) as? Images) {
        imageData.identifier = image.image.jpegData(compressionQuality: 0.8)!
        imageData.date = image.date
        coredataTypeArr.append(imageData)
      }
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

  // delete
  func delete(identifier: UUID) -> (Bool, Error?) {

    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext

    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
    fetchRequest.returnsObjectsAsFaults = false
    let predicate = NSPredicate(format: "identifier == %@", identifier as CVarArg)
    fetchRequest.predicate = predicate

    do {

      let fetchResults: Array = try managedContext.fetch(fetchRequest)

      for fetchResult in fetchResults {
        if let managedObject = fetchResult as? NSManagedObject {

          managedContext.delete(managedObject)
        }
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

  // update
  func update(updateMemo: MemoData) -> (Bool, Error?) {
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
    fetchRequest.returnsObjectsAsFaults = false
    let predicate = NSPredicate(format: "identifier == %@", updateMemo.identifier! as CVarArg)
    fetchRequest.predicate = predicate
    fetchRequest.fetchLimit = 1
    var coredataTypeArr: [Images] = []
    for image in updateMemo.imageArray ?? [] {
      if let imageData = (NSEntityDescription.insertNewObject(forEntityName: "Images",
                                                              into: managedContext) as? Images) {
        imageData.identifier = image.image.jpegData(compressionQuality: 0.8)!
        imageData.date = image.date
        coredataTypeArr.append(imageData)
      }
    }
    do {
      let fetchResult = try managedContext.fetch(fetchRequest).first
      if let managedObject = fetchResult as? NSManagedObject {
        managedObject.setValue(updateMemo.title, forKey: "title")
        managedObject.setValue(updateMemo.memo, forKey: "memo")
        managedObject.setValue(updateMemo.date, forKey: "date")
        managedObject.setValue(updateMemo.modifyDate, forKey: "modifyDate")
        managedObject.setValue(NSSet(array: coredataTypeArr), forKey: "images")
      }
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

  // fetch all memo
  func fetchAllMemos() -> [Memo]? {
    let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
    let fetchRequest2 = NSFetchRequest<Memo>(entityName: "Memo")
    // unit test check
    if NSClassFromString("XCTest") != nil {
      fetchRequest2.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
    } else {
      let orderType = userPreferences.getOrderType()
      switch orderType {
      case .title:
        fetchRequest2.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true,
                                                          selector: #selector(NSString.localizedCaseInsensitiveCompare))]
      case .createDate:
        fetchRequest2.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
      case .modifyDate:
        fetchRequest2.sortDescriptors = [NSSortDescriptor(key: "modifyDate", ascending: false)]
      }
    }
    do {
      let memos = try managedContext.fetch(fetchRequest2)
      return memos
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
      return nil
    }

  }

  // flush
  func flushData() {

    let container = NSPersistentContainer(name: "MemoApp")

    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "Memo")
    if let objs = try? CoreDataManager.sharedManager.persistentContainer.viewContext.fetch(fetchRequest) {
      for case let obj as NSManagedObject in objs {
        CoreDataManager.sharedManager.persistentContainer.viewContext.delete(obj)
      }
      try? CoreDataManager.sharedManager.persistentContainer.viewContext.save()
    }
  }

  func reset() {
    let container = persistentContainer
    let coordinator = container.persistentStoreCoordinator
    if let store = coordinator.destroyPersistentStore(type: NSSQLiteStoreType) {
      do {
        try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                           configurationName: nil,
                                           at: store.url,
                                           options: nil)
      } catch {
        print(error)
      }
    }

  }

  @objc private func contextObjectDidChange(_ notification: NSNotification) {
    NotificationCenter.default.post(name: .memoDataChanged, object: self)
  }
}

extension NSPersistentStoreCoordinator {
  func destroyPersistentStore(type: String) -> NSPersistentStore? {
    guard
      let store = persistentStores.first(where: { $0.type == type }),
      let storeURL = store.url
      else {
        return nil
    }

    try? destroyPersistentStore(at: storeURL, ofType: store.type, options: nil)

    return store
  }

}
