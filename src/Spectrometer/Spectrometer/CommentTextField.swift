//
//  CommentTextField.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 08.03.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class CommentTextField: BaseTextField {
    
    override var isValid: Bool {
        get {
            return text == nil || text!.lengthOfBytes(using: String.Encoding.utf8) < 157 // Comment can only have 157 Characters as described in the indico documentation
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
