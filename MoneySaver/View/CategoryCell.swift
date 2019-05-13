//
//  CategoryCell.swift
//  MoneySaver
//
//  Created by Руслан Кукса on 5/6/19.
//  Copyright © 2019 Ruslan Kuksa. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
