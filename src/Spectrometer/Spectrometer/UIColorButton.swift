//
//  UIColorButton.swift
//  Spectrometer
//
//  Created by raphi on 15.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class UIColorButton: UIButton {
    
    @IBInspectable var background: UIColor = UIColor.clear {
        didSet {
            layer.backgroundColor = background.cgColor
        }
    }
    
    @IBInspectable var fontColor: UIColor = UIColor.clear {
        didSet {
            setTitleColor(fontColor, for: .normal)
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    override var isEnabled: Bool {
        
        didSet {
            
            switch isEnabled {
            case true:
                backgroundColor = background
            default:
                backgroundColor = background.withAlphaComponent(0.25)
            }
            
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isEnabled {
            backgroundColor = background
        } else {
            backgroundColor = background.withAlphaComponent(0.25)
        }
        
    }
    
}
