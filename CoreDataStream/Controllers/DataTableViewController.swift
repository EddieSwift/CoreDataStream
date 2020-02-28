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
    lazy var coreDataStack = CoreDataStack(modelName: "CoreDataStream")
    var activityIndicator: UIActivityIndicatorView!
    var currentCompany: Company?
    var allCompanies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupActivityIndicator()
        
        generateObjects()
        fetchAllObjects()
        
        ObjectTableViewCell.register(in: tableView)
    }
    
    // MARK: - Generate and Fetch Methods
    
    private func generateObjects() {
        
        // Set User Defaults
        let userDefaults = UserDefaults.standard
        guard userDefaults.object(forKey: "didGenerateObjects") == nil else { return }
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(managedObjectContextDidSave), name: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: coreDataStack.backgroundContext)
        
        let start = DispatchTime.now()
        
        for index in 0..<1000 {
            self.currentCompany = Company(context: self.coreDataStack.managedObjectContext)
            if let companyName = EmployeeData.companies.randomElement() {
                self.currentCompany?.name = companyName + " \(index)"
            }
        }
        
        do {
            try coreDataStack.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
        
        coreDataStack.backgroundContext.performAndWait {
            DispatchQueue.main.async {
                for index in 0..<99_000 {
                    self.currentCompany = Company(context: self.coreDataStack.backgroundContext)
                    if let companyName = EmployeeData.companies.randomElement() {
                        self.currentCompany?.name = companyName + " \(index)"
                    }
                }
                
                do {
                    try self.coreDataStack.backgroundContext.save()
                    self.coreDataStack.backgroundContext.performAndWait {
                        do {
                            try self.coreDataStack.backgroundContext.save()
                        } catch {
                            fatalError("Failure to save context: \(error)")
                        }
                    }
                } catch {
                    fatalError("Failure to save context: \(error)")
                }
            }
        }
        
        // Update User Defaults
        userDefaults.set(true, forKey: "didGenerateObjects")
        
        let end = DispatchTime.now()
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        print("Time in generateObjects: \(timeInterval) seconds")
    }
    
    @objc func managedObjectContextDidSave(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count == 99_000 {
            print("BINGOOOOO")
        }
    }
    
    private func fetchAllObjects() {
        
        let start = DispatchTime.now()
        
        startAnimation()
        
        // Creates a fetch request to get all saved companies
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Company")
        
        // Creates asynchronousFetchRequest with the fetch request
        
        let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) { asynchronousFetchResult in
            
            // Retrieves an array of companies from the fetch result finalResult
            guard let result = asynchronousFetchResult.finalResult as? [Company] else { return }
            
            // Dispatches to use the data in the main queue
            DispatchQueue.main.async {
                self.allCompanies = result
                self.tableView.reloadData()
                self.stopAnimation()
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
