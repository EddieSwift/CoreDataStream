//
//  ObjectTableViewCell.swift
//  CoreDataStream
//
//  Created by Eduard Galchenko on 21.02.2020.
//  Copyright © 2020 Eduard Galchenko. All rights reserved.
//

import UIKit

class ObjectTableViewCell: UITableViewCell {
    
    @IBOutlet weak var employeeDetails: UILabel!
    
    // MARK: - Methods
    
    public static func register(in tableView: UITableView) {
        let nib = UINib.init(nibName: "ObjectTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "ObjectTableViewCell")
    }
    
    func configure(with employee: Employee, company: String?) {
        if let name = employee.firstName, let surname = employee.lastName, let company = company {
            self.employeeDetails?.text = "\(name) \(surname), age:\(employee.age) works at: \(company)"
        }
    }
    
    func configure(with company: Company) {
        if let companyName = company.name {
            self.employeeDetails?.text = "Comapny: \(companyName)"
        }
    }
    
}
