//
//  TextFieldVIew.swift
//  MoneySaver
//
//  Created by Руслан Кукса on 5/6/19.
//  Copyright © 2019 Ruslan Kuksa. All rights reserved.
//

import UIKit

@IBDesignable
class TextFieldVIew: UITextField, UITextFieldDelegate {
    
    let bottomLine = CALayer()
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += labelPadding

        return textRect
    }
    
    @IBInspectable var labelPadding: CGFloat = 0
    
    @IBInspectable var labelText: String? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var lineColor: UIColor = UIColor.darkGray {
        didSet {
            updateView()
        }
    }
    
    var lineHeight: CGFloat = 1 {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        leftViewMode = UITextField.ViewMode.always
        let labelView = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        labelView.text = labelText
        leftView = labelView
        
        bottomLine.frame = CGRect(x: 0, y: frame.height - 1, width: frame.width, height: lineHeight)
        bottomLine.backgroundColor = lineColor.cgColor
        layer.addSublayer(bottomLine)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: frame.width / 2 - 50, bottom: 0, right: 10))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: frame.width / 2 - 50, bottom: 0, right: 10))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: UIEdgeInsets(top: 0, left: frame.width / 2 - 50, bottom: 0, right: 10))
    }
    
}
