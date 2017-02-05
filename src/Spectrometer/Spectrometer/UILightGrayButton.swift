//
//  UILightGrayButton.swift
//  Spectrometer
//
//  Created by raphi on 05.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class UILightGrayButton : UIButton {
    
    private let red:UIColor = UIColor.red
    private let selectedText:UIColor = UIColor.gray
    private let gray:UIColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:1.00)
    private let lightGray:UIColor = UIColor(red:0.92, green:0.92, blue:0.92, alpha:0.50)
    
    override var isEnabled: Bool {
        
        didSet {
            
            switch isEnabled {
            case true:
                backgroundColor = gray
            default:
                backgroundColor = lightGray
            }
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 4
        
        self.backgroundColor = lightGray
        if (isEnabled) {
            self.backgroundColor = gray
        }
        
        setTitleColor(red, for: .normal)
        
        setTitleColor(selectedText, for: .focused)
        setTitleColor(selectedText, for: .highlighted)
        setTitleColor(selectedText, for: .selected)
        
        
    }
    
}
