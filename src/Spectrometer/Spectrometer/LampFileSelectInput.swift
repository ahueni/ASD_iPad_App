//
//  LampFileSelectInput.swift
//  Spectrometer
//
//  Created by raphi on 21.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class LampFileSelectInput: BaseCalibrationFileSelectInput {
    
    override var isValid: Bool {
        get {
            
            if isInEditMode {
                return true
            }
            
            if let file = calibrationFile {
                return file.dataType == .IrradType
            }
            return false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
