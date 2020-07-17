//
//  Images+CoreDataProperties.swift
//  MemoApp
//
//  Created by LEE HAEUN on 2020/07/18.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//
//

import Foundation
import CoreData


extension Images {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Images> {
        return NSFetchRequest<Images>(entityName: "Images")
    }

    @NSManaged public var date: Date?
    @NSManaged public var identifier: Data?
    @NSManaged public var images: Memo?

}
