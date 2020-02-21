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
    
//    let persistentContainer: NSPersistentContainer = {
//        let container = NSPersistentContainer(name: "CoreDataStream")
//        container.loadPersistentStores(completionHandler: { _, error in
//            guard error == nil else {
//                fatalError("Failed to load store")
//            }
//            DispatchQueue.main.async {  }
//        })
//        return container
//    }()
    
//    func fetchData() -> [Company] {
//        let context = persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<Company>(entityName: "Company")
//        do {
//            let companies = try context.fetch(fetchRequest)
//            return companies
//        } catch let fetchErr {
//            print("Failed to fetch companies", fetchErr.localizedDescription)
//            return []
//        }
//    }
//    
//    func deleteAll(completion: (_ error: String?) -> Void) {
//        let context = persistentContainer.viewContext
//        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
//        do {
//            try context.execute(batchDeleteRequest)
//            completion(nil)
//        } catch let batchErr {
//            let err = "Failed to delete all data: \(batchErr.localizedDescription)"
//            completion(err)
//        }
    }
    
//    func createEmployee(company: Company, name: String, type: String, birthday: Date) -> (Employee? ,Error?) {
//        let context = persistentContainer.viewContext
//
//        let employee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context) as! Employee
//        employee.company = company
//        employee.name = name
//        employee.type = type
//
//        let employeeInfo = NSEntityDescription.insertNewObject(forEntityName: "EmployeeInfo", into: context) as! EmployeeInfo
//        employeeInfo.birthday = birthday
//        employee.employeeInfo = employeeInfo
//
//        do {
//            try context.save()
//            return (employee, nil)
//        } catch let saveErr {
//            return (nil, saveErr)
//        }
//    }


//import CoreData
//
//import CoreData
//
//public class CoreDataService {
//    public static let shared = CoreDataService()
//    // Data
//    public var backgroundContext: NSManagedObjectContext!
//    private init() {
//        createContainer { container in
//            self.backgroundContext = container.newBackgroundContext()
//        }
//    }
////    func fetchAllAnswers() -> [Employee] {
////        let fetchRequest =
////            NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
////        do {
////            guard let answers = try backgroundContext.fetch(fetchRequest) as? [Employee] else { return [] }
////            return answers
////        } catch let error as NSError {
////            print("Could not fetch. \(error), \(error.userInfo)")
////        }
////        return []
////    }
//
//    func fetchAllAnswers() -> [Company] {
//        var fetchResults: [Company] = []
//        guard let context = backgroundContext else { return [Company]() }
//
//        context.performAndWait {
//            let fetchRequest: NSFetchRequest<Company> = Company.fetchRequest()
//
//            do {
//                fetchResults = try backgroundContext.fetch(fetchRequest)
//            } catch {
//                fatalError("Fetch error")
//            }
//        }
//
//        return fetchResults
//    }
//
//    public func save(_ name: String) {
//
//        guard let context = backgroundContext else { return }
//        guard let answer = NSEntityDescription.insertNewObject(forEntityName: "Company",
//                                                               into: context) as? Company else { return }
//        answer.name = name
//
//        do {
//            try context.save()
//        } catch {
//            print(error)
//        }
//    }
//
//    /*
//     public func save(_ text: String) {
//         guard let context = backgroundContext else { return }
//         guard let answer = NSEntityDescription.insertNewObject(forEntityName: "CustomAnswer",
//                                                                into: context) as? CustomAnswer else { return }
//         answer.answerText = text
//         do {
//             try context.save()
//         } catch {
//             print(error)
//         }
//     }
//     */
//
//    func delete(_ answer: NSManagedObject) {
//        guard let context = backgroundContext else { return }
//        context.delete(answer)
//        do {
//            try context.save()
//        } catch let error as NSError {
//            print("Error While Deleting Note: \(error.userInfo)")
//        }
//    }
//
//    private func createContainer(completion: @escaping
//        (NSPersistentContainer) -> Void) { let container = NSPersistentContainer(name:
//        "CoreDataStream")
//        container.loadPersistentStores(completionHandler: { _, error in
//            guard error == nil else {
//                fatalError("Failed to load store")
//            }
//            DispatchQueue.main.async { completion(container) }
//        })
//    }
//}
