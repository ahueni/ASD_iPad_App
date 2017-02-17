//
//  SelectPathInput.swift
//  Spectrometer
//
//  Created by raphi on 17.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomTextField:UITextField {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // layout customTextField
        self.borderStyle = .line
        self.textColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.00)
        
        layer.borderColor = UIColor(red:0.84, green:0.84, blue:0.84, alpha:1.00).cgColor
        layer.backgroundColor = UIColor.white.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        
        //let image = UIImage.fontAwesomeIcon(name: .fileO, textColor: .black, size: CGSize(width: 16.0, height: 16.0))
        //self.leftView = UIImageView(image: image)
        
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: calculateTextInset(rect: rect))
    }
    
    override func drawPlaceholder(in rect: CGRect) {
        super.drawPlaceholder(in: calculateTextInset(rect: rect))
    }
    
    func calculateTextInset(rect: CGRect) -> CGRect {
        
        let x = rect.origin.x + 8
        let y = rect.origin.y
        let width = rect.width - 16
        let height = rect.height
        
        return CGRect(x: x, y: y, width: width, height: height)
        
    }
    
}
