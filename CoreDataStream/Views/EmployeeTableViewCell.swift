//
//  EmployeeTableViewCell.swift
//  CoreDataStream
//
//  Created by Eduard Galchenko on 21.02.2020.
//  Copyright © 2020 Eduard Galchenko. All rights reserved.
//

import UIKit

class EmployeeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var employeeDetails: UILabel!
    
    // MARK: - Methods
    
    public static func register(in tableView: UITableView) {
        let nib = UINib.init(nibName: "EmployeeTableViewCell", bundle: Bundle.main)
        tableView.register(nib, forCellReuseIdentifier: "EmployeeTableViewCell")
    }
    
    func configure(with employee: Employee, company: String?) {
        if let name = employee.firstName, let surname = employee.lastName, let company = company {
            self.employeeDetails?.text = "\(name) \(surname), age:\(employee.age) works at: \(company)"
        }
    }
    
}
