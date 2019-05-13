//
//  Cell.swift
//  MoneySaver
//
//  Created by Руслан Кукса on 5/5/19.
//  Copyright © 2019 Ruslan Kuksa. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {
    
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var noteLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
