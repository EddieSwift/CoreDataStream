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
    
    let coreDataService = CoreDataService.shared
    
    lazy var coreDataStack = CoreDataStack(modelName: "CoreDataStream")
    
    var currentCompany: Company?

    private var allEmployees = [Company]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        generateEmployees()
        
        print("Hello")
        
//        let companyFetch: NSFetchRequest<Company> = Company.fetchRequest()
//
//        do {
//            let results = try coreDataStack.managedContext.fetch(companyFetch)
//            if results.count > 0 {
//                // Fido found, use Fido
//                currentCompany = results.first
//                print(currentCompany?.name)
//            }



        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        print("allEmployees.count: \(allEmployees.count)")
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        allEmployees = coreDataService.fetchAllAnswers()
//    }
    
    // MARK: - Help Methods
    
    private func generateEmployees() {
        
        let company = "Apple"
        let companyFetch: NSFetchRequest<Company> = Company.fetchRequest()
        companyFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Company.name), company)
        
        do {
          let results = try coreDataStack.managedContext.fetch(companyFetch)
          if results.count > 0 {
            // Fido found, use Fido
            currentCompany = results.first
            print(currentCompany!.name!)
            allEmployees = results
          } else {
            // Fido not found, create Fido
            currentCompany = Company(context: coreDataStack.managedContext)
            currentCompany?.name = company
            coreDataStack.saveContext()
          }
        } catch let error as NSError {
          print("Fetch error: \(error) description: \(error.userInfo)")
        }
        
        
        let employee = Employee(context: coreDataStack.managedContext)
        employee.firstName = "Richi"
        employee.lastName = "Richi"
        
        if let company = currentCompany,
          let employees = company.employees?.mutableCopy() as? NSMutableOrderedSet {
          employees.add(employee)
            company.employees = employees
        }
        
        coreDataStack.saveContext()
}


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
