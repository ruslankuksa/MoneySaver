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
    var fetchedResultController: NSFetchedResultsController<Transaction>!
    
    let defaults = UserDefaults.standard
    var balance: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        balance = defaults.float(forKey: "Balance")
        balanceLabel.text = NSString(format: "%.2f", balance) as String
        
        //loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultController.sections!.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = self.fetchedResultController.sections else {
            fatalError("No sections in fetchedResultController")
        }
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        
        configureCell(cell, at: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: Cell, at indexPath: IndexPath) {
        guard let transaction = self.fetchedResultController?.object(at: indexPath) else {
            fatalError("Can't configure cell")
        }
        
        cell.categoryLabel.text = transaction.category
        cell.noteLabel.text = transaction.note ?? ""
        
        if transaction.expanse == true {
            cell.amountLabel.textColor = UIColor.red
            cell.amountLabel.text = "-\(transaction.amount)"
        } else {
            cell.amountLabel.textColor = UIColor.green
            cell.amountLabel.text = "+\(transaction.amount)"
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionInfo = fetchedResultController?.sections?[section] else {
            return nil
        }

        return sectionInfo.name
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.textAlignment = .center
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newTransaction" {
            let destinationVC = segue.destination as! NewTransactionController
            destinationVC.delegate = self
        }
    }
    
    func newTransaction(amount: Float, category: String, note: String, date: Date, spend: Bool) {
        let transaction = Transaction(context: context)
        
        
        transaction.category = category
        transaction.note = note
        transaction.date = date
        transaction.amount = amount
        transaction.expanse = spend
        
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
        
        let fetchRequest: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: #keyPath(Transaction.isDate), cacheName: nil)
        fetchedResultController.delegate = self
        
        do {
            try fetchedResultController.performFetch()
        } catch {
            print("Load data error: \(error)")
        }
     
        tableView.reloadData()
    }

}

extension Transaction {
    
    @objc var isDate: String {
        get {
            let dateFromatter = DateFormatter()
            dateFromatter.dateFormat = "MMMM dd"
            
            return dateFromatter.string(from: date!)
        }
    }
}

extension ViewController: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                print("Added:\(indexPath)")
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        case .delete:
            if let indexPath = indexPath {
                print("Delete:\(indexPath)")
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update:
            if let indexPath = indexPath {
                print("Update:\(indexPath)")
                let cell = tableView.cellForRow(at: indexPath) as! Cell
                configureCell(cell, at: indexPath)
            }
            break
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let newIndexPath = newIndexPath {
                print("Move:\(newIndexPath)")
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break
        @unknown default:
            break
        }
        
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            break
        case .delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
            break
        default:
            break
        }
    }
}
