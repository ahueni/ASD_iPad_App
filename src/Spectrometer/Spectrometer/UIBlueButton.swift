//
//  UIBlueButton.swift
//  Spectrometer
//
//  Created by raphi on 05.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class UIBlueButton : UIButton {
    
    private let white:UIColor = UIColor.white
    private let gray:UIColor = UIColor.darkGray
    private let blue:UIColor = UIColor(red:0.00, green:0.65, blue:0.93, alpha:1.00)
    private let lightBlue:UIColor = UIColor(red:0.00, green:0.65, blue:0.93, alpha:0.25)
    
    override var isEnabled: Bool {
        
        didSet {
            
            switch isEnabled {
            case true:
                backgroundColor = blue
            default:
                backgroundColor = lightBlue
            }
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 4
        
        self.backgroundColor = lightBlue
        if (isEnabled) {
            self.backgroundColor = blue
        }
        
        setTitleColor(white, for: .normal)
        
        setTitleColor(gray, for: .focused)
        setTitleColor(gray, for: .highlighted)
        setTitleColor(gray, for: .selected)
        
        
    }
    
}
