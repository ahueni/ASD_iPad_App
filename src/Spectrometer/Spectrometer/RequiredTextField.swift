//
//  RequiredTextField.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 01.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RequiredTextField : BaseTextField {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func validate() {
        isValid = text != nil && text != ""
    }
}
