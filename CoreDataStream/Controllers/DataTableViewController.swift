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
    let rowHeight: CGFloat = 80.0
    lazy var coreDataStack = CoreDataStack(modelName: "CoreDataStream")
    var currentCompany: Company?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateEmployees()
        
        EmployeeTableViewCell.register(in: tableView)
        
    }
    
    // MARK: - Help Methods
    
    private func generateEmployees() {
        
        let company = "Apple"
        
        let companyFetch: NSFetchRequest<Company> = Company.fetchRequest()
        
        do {
            let results = try coreDataStack.backgroundContext.fetch(companyFetch)
            if results.count > 0 {
                currentCompany = results.first
                print(currentCompany!.name!)
                
            } else {
                currentCompany = Company(context: coreDataStack.backgroundContext)
                currentCompany?.name = company
                coreDataStack.saveContext()
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        
        if currentCompany != nil {
            for _ in 0...100 {
                let employee = Employee(context: coreDataStack.backgroundContext)
                employee.firstName = EmployeeData.names.randomElement()
                employee.lastName = EmployeeData.surnames.randomElement()
                employee.age = Int16(arc4random_uniform(18) + 42)
                
                if let company = currentCompany,
                    let employees = company.employees?.mutableCopy() as? NSMutableOrderedSet {
                    employees.add(employee)
                    company.employees = employees
                }
                
            }
        }
        
        coreDataStack.saveContext()
        
        tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension DataTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentCompany?.employees?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> EmployeeTableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EmployeeTableViewCell",
                                                       for: indexPath) as? EmployeeTableViewCell else {
                                                        fatalError("Cell error")
        }
        
        guard let employee = currentCompany?.employees?[indexPath.row] as? Employee else { return cell }
        
        cell.configure(with: employee, company: currentCompany?.name)
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
}
