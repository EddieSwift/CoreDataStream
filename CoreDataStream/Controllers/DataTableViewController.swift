//
//  DataTableViewController.swift
//  CoreDataStream
//
//  Created by Eduard Galchenko on 20.02.2020.
//  Copyright © 2020 Eduard Galchenko. All rights reserved.
//

import UIKit
import CoreData

class DataTableViewController: UITableViewController {
    
    // MARK: Properties
    let coreDataService = CoreDataService.shared
    lazy var coreDataStack = CoreDataStack(modelName: "CoreDataStream")
    var currentCompany: Company?
    var allCompanies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        generateObjects()
        fetchAllObjects()
        
        ObjectTableViewCell.register(in: tableView)
    }
    
    // MARK: - Generate and Fetch Methods
    
    private func generateObjects() {
        
        // Set User Defaults
        let userDefaults = UserDefaults.standard
        guard userDefaults.object(forKey: "didGenerateObjects") == nil else { return }
                
        let start = DispatchTime.now()
        
            for index in 0..<100_000 {
                currentCompany = Company(context: coreDataStack.backgroundContext)
                if let companyName = EmployeeData.companies.randomElement() {
                    currentCompany?.name = companyName + " \(index)"
                }
            }
            
            coreDataStack.saveContext()
        
        // Update User Defaults
        userDefaults.set(true, forKey: "didGenerateObjects")
        
        let end = DispatchTime.now()
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        print("Time in generateObjects: \(timeInterval) seconds")
    }
    
    private func fetchAllObjects() {
        
        let start = DispatchTime.now()

        // Creates a fetch request to get all saved companies
         let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Company")
         
         // Creates `asynchronousFetchRequest` with the fetch request
         let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asynchronousFetchResult in
             
             // Retrieves an array of companies from the fetch result `finalResult`
             guard let result = asynchronousFetchResult.finalResult as? [Company] else { return }
             
             // Dispatches to use the data in the main queue
             DispatchQueue.main.async {

                 self.allCompanies = result
                 print("allCompanies: \(self.allCompanies.count)")
                 self.tableView.reloadData()
             }
         }
         
         do {
             try coreDataStack.backgroundContext.execute(asynchronousFetchRequest)
         } catch let error {
             print("NSAsynchronousFetchRequest error: \(error)")
         }
        
        let end = DispatchTime.now()
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        print("Time in fetchAllObjects: \(timeInterval) seconds")
    }
    
}

// MARK: - UITableViewDataSource

extension DataTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allCompanies.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> ObjectTableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ObjectTableViewCell",
                                                       for: indexPath) as? ObjectTableViewCell else {
                                                        fatalError("Cell error")
        }
        
        let company = allCompanies[indexPath.row]
        cell.configure(with: company)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
    
}
