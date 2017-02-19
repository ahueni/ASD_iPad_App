//
//  BaseTextField.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 01.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class BaseTextField : UITextField, BaseValidationControl {
    
    var isValid: Bool = false{
        didSet
        {
            textColor = isValid ? .black : .red
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.addTarget(self, action: #selector(validate), for: .editingChanged)
    }
    
    func validate(){
    }
    
}
