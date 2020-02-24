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
    var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator()
        generateEmployees()
        
        EmployeeTableViewCell.register(in: tableView)
    }
    
    // MARK: - Help Methods
    
    private func generateEmployees() {
        
        let company = "Apple"
        
        startAnimation()
        
        let companyFetch: NSFetchRequest<Company> = Company.fetchRequest()
        
        do {
            let results = try coreDataStack.backgroundContext.fetch(companyFetch)
            if results.count > 0 {
                currentCompany = results.first
            } else {
                currentCompany = Company(context: coreDataStack.backgroundContext)
                currentCompany?.name = company
                coreDataStack.saveContext()
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        
        print("current amount of employees: \(currentCompany?.employees?.count ?? 0)")
        
        let start = DispatchTime.now()
        
        // check if we had created employees and added to Core Data
        if currentCompany?.employees?.count ?? 0 < 100_0  {
            for _ in 0...100_0  {
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
        
        print("amount of employees after creating: \(currentCompany?.employees?.count ?? 0)")
        let end = DispatchTime.now()
        
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        print("Time: \(timeInterval) seconds")
        
        tableView.reloadData()
        
        stopAnimation()
    }
}

// MARK: - UITableViewDataSource

extension DataTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("in numberOfRowsInSection: \(currentCompany?.employees?.count ?? 0)")
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
        return Constants.rowHeight
    }
    
}

// MARK: - SetupUI

extension DataTableViewController {
    
    private func setupActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.large)
        activityIndicator.color = .systemBlue
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
    }
    
    // MARK: - Indicator Methods
    
    private func startAnimation() {
        activityIndicator.startAnimating()
    }
    
    private func stopAnimation() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
}
