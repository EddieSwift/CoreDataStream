//
//  Company+CoreDataProperties.swift
//  CoreDataStream
//
//  Created by Eduard Galchenko on 20.02.2020.
//  Copyright © 2020 Eduard Galchenko. All rights reserved.
//
//

import Foundation
import CoreData

extension Company {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Company> {
        return NSFetchRequest<Company>(entityName: "Company")
    }

    @NSManaged public var name: String?
    @NSManaged public var relationship: NSSet?
}

// MARK: Generated accessors for relationship

extension Company {

    @objc(addRelationshipObject:)
    @NSManaged public func addToRelationship(_ value: Employee)

    @objc(removeRelationshipObject:)
    @NSManaged public func removeFromRelationship(_ value: Employee)

    @objc(addRelationship:)
    @NSManaged public func addToRelationship(_ values: NSSet)

    @objc(removeRelationship:)
    @NSManaged public func removeFromRelationship(_ values: NSSet)
}
