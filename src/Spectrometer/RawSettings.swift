//
//  RawSettings.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 14.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class RawSettings{
    var targetCount : Int
    var targetDelay : Int
    
    init(targetCount : Int, targetDelay : Int) {
        self.targetCount = targetCount
        self.targetDelay = targetDelay
    }
}
