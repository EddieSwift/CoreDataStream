//
//  CoreDataStack.swift
//  CoreDataStream
//
//  Created by Eduard Galchenko on 20.02.2020.
//  Copyright © 2020 Eduard Galchenko. All rights reserved.
//

import Foundation
import CoreData

protocol CoreDataStackProtocol {
    func construct(completion: @escaping () -> ())
    func mainContext() -> NSManagedObjectContext
    func workerContext() -> NSManagedObjectContext
    func saveContext(context: NSManagedObjectContext)
    func asyncWorkerContext(block: @escaping (NSManagedObjectContext?)->())
}

extension CoreDataStackProtocol {

    func construct(completion: @escaping () -> ()) {
        completion()
    }

    func saveContext(context: NSManagedObjectContext) {
        guard context.hasChanges else { return }
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    func createPSC() -> NSPersistentStoreCoordinator {
        let docDir = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
        let urlString = (docDir as NSString).appendingPathComponent("Company.sqlite")
        let storeURL = URL(fileURLWithPath: urlString)
        let bundles = [Bundle(for: Company.self)]
        guard let model = NSManagedObjectModel.mergedModel(from: bundles) else {
            fatalError("model not found")
        }
        let psc = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        return psc
    }

    func asyncWorkerContext(block: @escaping (NSManagedObjectContext?)->()) {
        block(workerContext())
    }
}

class CoreDataStack: CoreDataStackProtocol {
    
    private var mContext: NSManagedObjectContext!
    private var pContext: NSManagedObjectContext!

    init() {
        let psc = createPSC()
        pContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        pContext.persistentStoreCoordinator = psc
        mContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mContext.parent = pContext
    }

    func mainContext() -> NSManagedObjectContext {
        return mContext
    }

    func workerContext() -> NSManagedObjectContext {
        let newWorker = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        newWorker.parent = mContext
        return newWorker
    }
}
