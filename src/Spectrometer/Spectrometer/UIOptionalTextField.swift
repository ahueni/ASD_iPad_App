//
//  UIOptionalTextField.swift
//  Spectrometer
//
//  Created by raphi on 01.03.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class OptionalTextField : BaseTextField {
    
    override var isValid: Bool {
        get {
            return true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
