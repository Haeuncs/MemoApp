//
//  Images+CoreDataProperties.swift
//  Memo_programmers
//
//  Created by LEE HAEUN on 2020/02/22.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//
//

import Foundation
import CoreData


extension Images {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Images> {
        return NSFetchRequest<Images>(entityName: "Images")
    }

    @NSManaged public var identifier: Data?
    @NSManaged public var date: Date?
    @NSManaged public var images: Memo?

}
