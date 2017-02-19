//
//  PortTextField.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 01.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class PortTextField : BaseTextField {
    
    override func validate(){
        let port = Int(text!)
        isValid = port != nil && port! >= 0 && port! <= 65535
    }
    
}
