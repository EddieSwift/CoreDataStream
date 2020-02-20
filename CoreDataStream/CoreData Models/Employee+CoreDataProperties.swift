//
//  Employee+CoreDataProperties.swift
//  CoreDataStream
//
//  Created by Eduard Galchenko on 20.02.2020.
//  Copyright © 2020 Eduard Galchenko. All rights reserved.
//
//

import Foundation
import CoreData


extension Employee {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var age: Int16
    @NSManaged public var relationship: Company?

}
