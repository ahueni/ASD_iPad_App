//
//  IPNumberTextField.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 01.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class IPNumberTextField : BaseTextField{
    
    override func validate()
    {
        isValid = Regex.valideIp(ip: text)
    }
    
}
