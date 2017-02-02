//
//  ValidationManager.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 01.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class ValidationManager{
    static let sharedInstance = ValidationManager()
    
    // prevent other instances of this class
    private init() {
    }
    
    public func validateSubViews(view :UIView) -> Bool
    {
        return validateSubViews(view: view, valid: true)
    }
    
    private func validateSubViews(view : UIView, valid : Bool) -> Bool{
        var validCopy = valid
        for subView in view.subviews{
            validCopy = validateSubViews(view: subView, valid: validCopy)
            if subView is BaseValidationControl{
                if (!(subView as! BaseValidationControl).isValid){
                    validCopy = false
                }
            }
        }
        return validCopy
    }

}
