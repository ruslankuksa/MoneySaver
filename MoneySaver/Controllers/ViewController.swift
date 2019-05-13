//
//  ViewController.swift
//  MoneySaver
//
//  Created by Руслан Кукса on 5/4/19.
//  Copyright © 2019 Ruslan Kuksa. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TransactionHandler {
    
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var operations = [Expense]()
    
    let defaults = UserDefaults.standard
    var balance: Float = 0
    
    //var transactionDates: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        balance = defaults.float(forKey: "Balance")
        balanceLabel.text = NSString(format: "%.2f", balance) as String
        
        loadData()
        //datesCount()
    }
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return transactionDates.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        
        cell.categoryLabel.text = operations[indexPath.row].category
        cell.noteLabel.text = operations[indexPath.row].note ?? ""
        
        if operations[indexPath.row].expanse == true {
            cell.amountLabel.textColor = UIColor.red
            cell.amountLabel.text = "-\(operations[indexPath.row].amount)"
        } else {
            cell.amountLabel.textColor = UIColor.green
            cell.amountLabel.text = "+\(operations[indexPath.row].amount)"
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let dateString = transactionDates[section]
//        return dateString
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newTransaction" {
            let destinationVC = segue.destination as! NewTransactionController
            destinationVC.delegate = self
        }
    }
    
    func newTransaction(amount: Float, category: String, note: String, date: Date, spend: Bool) {
        let transaction = Expense(context: context)
        
        transaction.category = category
        transaction.note = note
        transaction.date = date
        transaction.amount = amount
        transaction.expanse = spend
        
        operations.append(transaction)
        
        saveData()
        
        if spend == true {
            balance -= transaction.amount
            defaults.set(balance, forKey: "Balance")
            
        } else {
            balance += transaction.amount
            defaults.set(balance, forKey: "Balance")
        }
        
        balanceLabel.text = NSString(format: "%.2f", balance) as String
    }
    
    func saveData() {
        
        do {
            try context.save()
        } catch {
            print("Saving error: \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData() {
        
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        do {
            operations = try context.fetch(fetchRequest)
        } catch {
            print("Load data error: \(error)")
        }
     
        tableView.reloadData()
    }
    
//    func datesCount() {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd MMM YYYY"
//        //dateFormatter.dateStyle = .medium
//
//        if !(operations.isEmpty) {
//            for each in operations {
//                if !(transactionDates.contains(dateFormatter.string(from: each.date!))) {
//                    transactionDates.append(dateFormatter.string(from: each.date!))
//                }
//            }
//        }
//    }

}

