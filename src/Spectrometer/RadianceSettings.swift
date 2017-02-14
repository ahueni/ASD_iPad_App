//
//  RadianceSettings.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 14.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class RadianceSettings : ReflectanceSettings{
    
    var whiteRefrenceBeforeCount : Int
    var whiteRefrenceBeforeDelay : Int
    var takeWhiteRefrenceAfter : Bool
    var whiteRefrenceAfterCount : Int
    var whiteRefrenceAfterDelay : Int
    
    init(targetCount : Int, targetDelay : Int, takeWhiteRefrenceBefore : Bool, whiteRefrenceBeforeCount : Int, takeWhiteRefrenceAfter : Bool, whiteRefrenceAfterCount : Int, whiteRefrenceBeforeDelay : Int, whiteRefrenceAfterDelay : Int) {
        self.whiteRefrenceBeforeCount = whiteRefrenceBeforeCount
        self.takeWhiteRefrenceAfter = takeWhiteRefrenceAfter
        self.whiteRefrenceAfterCount = whiteRefrenceAfterCount
        self.whiteRefrenceBeforeDelay = whiteRefrenceBeforeDelay
        self.whiteRefrenceAfterDelay = whiteRefrenceAfterDelay
        super.init(targetCount: targetCount, targetDelay: targetDelay, takeWhiteRefrenceBefore: takeWhiteRefrenceBefore)
    }
}
