//
//  Memo+CoreDataProperties.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/16.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var date: Date?
    @NSManaged public var identifier: UUID?
    @NSManaged public var memo: String?
    @NSManaged public var title: String?
    @NSManaged public var images: Images?

}
