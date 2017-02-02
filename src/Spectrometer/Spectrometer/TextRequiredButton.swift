//
//  TextRequiredButton.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 01.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class TextRequiredButton : BaseButton{
    override func validate() {
        isValid = currentTitle != nil && currentTitle != ""
    }
}
