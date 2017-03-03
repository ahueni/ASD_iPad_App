//
//  NumberTextField.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 01.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class NumberTextField : BaseTextField {
    
    var number : Int {
        get{
            if let number = Int(text!)
            {
                return number
            }
            return  0
        }
    }
    
    override var isValid: Bool {
        get {
            let number = Int(text!)
            return number != nil
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
