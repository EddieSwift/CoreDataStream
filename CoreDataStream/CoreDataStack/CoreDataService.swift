//
//  CoreDataService.swift
//  CoreDataStream
//
//  Created by Eduard Galchenko on 20.02.2020.
//  Copyright © 2020 Eduard Galchenko. All rights reserved.
//

import CoreData
import Foundation

struct CoreDataService {
    
    static let shared = CoreDataService()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataStream")
        container.loadPersistentStores { (storeDescription, err) in
            if let err = err {
                fatalError("Loading of storage is failed: \(err.localizedDescription)")
            }
        }
        return container
    }()
    
}
