//
//  ReflectanceSettings.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 14.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class ReflectanceSettings : RawSettings{
    var takeWhiteRefrenceBefore : Bool
    
    init(targetCount : Int, targetDelay : Int, takeWhiteRefrenceBefore : Bool) {
        self.takeWhiteRefrenceBefore = takeWhiteRefrenceBefore
        super.init(targetCount: targetCount, targetDelay: targetDelay)
    }
}
