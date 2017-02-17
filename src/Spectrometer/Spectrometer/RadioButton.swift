//
//  RadioButton.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 14.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class RadioButton: UIButton {
    
    var alternateButton:[RadioButton] = []
    
    private let white:UIColor = UIColor.white
    private let gray:UIColor = UIColor.darkGray
    private let blue:UIColor = UIColor(red:0.00, green:0.65, blue:0.93, alpha:1.00)
    private let lightBlue:UIColor = UIColor(red:0.00, green:0.65, blue:0.93, alpha:0.25)
    
    func unselectAlternateButtons(){
        
        if alternateButton.isEmpty {
            toggleButton()
        } else {
            self.isSelected = true
            for aButton:RadioButton in alternateButton {
                aButton.isSelected = false
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        unselectAlternateButtons()
        super.touchesBegan(touches, with: event)
    }
    
    func toggleButton(){
        self.isSelected = !isSelected
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.cornerRadius = 4
        
        self.backgroundColor = lightBlue
        if (isEnabled) {
            self.backgroundColor = blue
        }
        
        setTitleColor(white, for: .normal)
        
        
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.backgroundColor = blue
            } else {
                self.backgroundColor = UIColor.lightGray
            }
        }
    }
}
