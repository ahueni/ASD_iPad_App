//
//  BaseValidationControl.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 01.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

protocol BaseValidationControl {
    
    var isValid : Bool {get}
    func validate()
    
}
