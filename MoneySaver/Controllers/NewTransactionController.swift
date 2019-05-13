//
//  NewExpanseController.swift
//  MoneySaver
//
//  Created by Руслан Кукса on 5/6/19.
//  Copyright © 2019 Ruslan Kuksa. All rights reserved.
//

import UIKit

protocol TransactionHandler {
    func newTransaction(amount: Float, category: String, note: String, date: Date, spend: Bool)
}

class NewTransactionController: UIViewController, Category {
   
    @IBOutlet var amountTextField: TextFieldVIew!
    @IBOutlet var categoryTextField: TextFieldVIew!
    @IBOutlet var noteTextField: TextFieldVIew!
    @IBOutlet var dateTextField: TextFieldVIew!
    @IBOutlet var datePicker: UIDatePicker!
    
    var moneySpend: Bool = true
    var delegate: TransactionHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        datePicker.isHidden = true
        updateDate()
        
        datePicker.addTarget(self, action: #selector(updateDate), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDatePicker))
        dateTextField.addGestureRecognizer(tapGesture)
        
    }
    
    @IBAction func segmentedSwitcher(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            moneySpend = true
        } else {
            moneySpend = false
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        let floatNumber = (amountTextField.text! as NSString).floatValue
        if floatNumber == 0 {
            let alert = UIAlertController(title: "Transaction details", message: "Enter transaction amount", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            delegate?.newTransaction(amount: floatNumber, category: categoryTextField.text!, note: noteTextField.text!, date: datePicker.date, spend: moneySpend)
            navigationController?.popToRootViewController(animated: true)
        }

    }
    
    @objc func updateDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM YYYY"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        dateTextField.text = selectedDate
    }
    
    @objc func showDatePicker() {
        datePicker.isHidden = false
        dateTextField.isEnabled = false
    }
    
    func selectedCategory(category: String) {
        categoryTextField.text = category
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCategories" {
            let destinationVC = segue.destination as! CategoriesController
            destinationVC.spend = moneySpend
            destinationVC.delegate = self
        }
    }
    
}
