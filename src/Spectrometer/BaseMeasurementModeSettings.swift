//
//  BaseModeSettings.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 28.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class BaseMeasurementModeSettings : NSObject, NSCoding
{
    required init(coder decoder: NSCoder) {
        self.targetCount = Int(decoder.decodeInt32(forKey: "targetCount"))
        self.targetDelay = Int(decoder.decodeInt32(forKey: "targetDelay"))
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.targetCount, forKey: "targetCount")
        aCoder.encode(self.targetDelay, forKey: "targetDelay")
    }
    
    var targetCount: Int
    var targetDelay: Int
    
    init(targetCount: Int, targetDelay: Int) {
        self.targetCount = targetCount
        self.targetDelay = targetDelay
    }

}
