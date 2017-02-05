//
//  UIGreenButton.swift
//  Spectrometer
//
//  Created by raphi on 05.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class UIGreenButton : UIButton {
    
    private let white:UIColor = UIColor.white
    private let gray:UIColor = UIColor.darkGray
    private let green:UIColor = UIColor(red:0.09, green:0.76, blue:0.28, alpha:1.00)
    private let lightGreen:UIColor = UIColor(red:0.09, green:0.76, blue:0.28, alpha:0.40)
    
    override var isEnabled: Bool {
        
        didSet {
            
            switch isEnabled {
            case true:
                backgroundColor = green
            default:
                backgroundColor = lightGreen
            }
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 4
        
        self.backgroundColor = lightGreen
        if (isEnabled) {
            self.backgroundColor = green
        }
        
        setTitleColor(white, for: .normal)
        
        setTitleColor(gray, for: .focused)
        setTitleColor(gray, for: .highlighted)
        setTitleColor(gray, for: .selected)
        
        
    }
    
}
