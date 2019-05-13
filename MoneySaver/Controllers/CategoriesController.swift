//
//  CategoriesController.swift
//  MoneySaver
//
//  Created by Руслан Кукса on 5/6/19.
//  Copyright © 2019 Ruslan Kuksa. All rights reserved.
//

import UIKit

protocol Category {
    func selectedCategory(category: String)
}

class CategoriesController: UITableViewController {
    
    var spend = Bool()
    var delegate: Category?
    
    let expenseCategories: [String] = ["Health", "Restaurants", "Transport", "Shopping", "Billings", "Gifts", "Animals", "Taxes", "Travels", "Entertainment", "Education"]
    let incomeCategories: [String] = ["Salary", "Deposit Interest", "Gift", "Business income", "Stock market"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return spend ? expenseCategories.count : incomeCategories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! CategoryCell
        
        if spend == true {
            cell.categoryLabel.text = expenseCategories[indexPath.row]
        } else {
            cell.categoryLabel.text = incomeCategories[indexPath.row]
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = tableView.cellForRow(at: indexPath) as! CategoryCell
        
        delegate?.selectedCategory(category: selectedCell.categoryLabel.text!)
        navigationController?.popViewController(animated: true)
    }

}
