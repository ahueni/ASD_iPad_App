//
//  AbsoluteReflectanceSelectInput.swift
//  Spectrometer
//
//  Created by raphi on 21.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class AbsoluteReflectanceFileSelectInput: BaseCalibrationFileSelectInput {
    
    override var isValid: Bool {
        get {
            
            // in editMode its always true
            if isInEditMode {
                return true
            }
            
            // its optional if its empty its valid otherwise it hase to be a Reflectance Type
            if let calibrationFile = calibrationFile {
                return calibrationFile.dataType == .RefType
            } else {
                return true
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
