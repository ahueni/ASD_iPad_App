//
//  RadianceSettings.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 14.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class RadianceSettings: ReflectanceSettings{
    
    required init(coder decoder: NSCoder) {
        self.whiteRefrenceBeforeCount = Int(decoder.decodeInt32(forKey: "whiteRefrenceBeforeCount"))
        self.whiteRefrenceBeforeDelay = Int(decoder.decodeInt32(forKey: "whiteRefrenceBeforeDelay"))
        self.takeWhiteRefrenceAfter = decoder.decodeBool(forKey: "takeWhiteRefrenceAfter")
        self.whiteRefrenceAfterCount = Int(decoder.decodeInt32(forKey: "whiteRefrenceAfterCount"))
        self.whiteRefrenceAfterDelay = Int(decoder.decodeInt32(forKey: "whiteRefrenceAfterDelay"))
        super.init(coder: decoder)
    }
    
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.whiteRefrenceBeforeCount, forKey: "whiteRefrenceBeforeCount")
        aCoder.encode(self.whiteRefrenceBeforeDelay, forKey: "whiteRefrenceBeforeDelay")
        aCoder.encode(self.takeWhiteRefrenceAfter, forKey: "takeWhiteRefrenceAfter")
        aCoder.encode(self.whiteRefrenceAfterCount, forKey: "whiteRefrenceAfterCount")
        aCoder.encode(self.whiteRefrenceAfterDelay, forKey: "whiteRefrenceAfterDelay")
    }
    
    var whiteRefrenceBeforeCount: Int
    var whiteRefrenceBeforeDelay: Int
    var takeWhiteRefrenceAfter: Bool
    var whiteRefrenceAfterCount: Int
    var whiteRefrenceAfterDelay: Int
    
    
    init(takeDarkCurrent: Bool, targetCount: Int, targetDelay: Int, takeWhiteRefrenceBefore: Bool, whiteRefrenceBeforeCount: Int, takeWhiteRefrenceAfter: Bool, whiteRefrenceAfterCount: Int, whiteRefrenceBeforeDelay: Int, whiteRefrenceAfterDelay: Int) {
        self.whiteRefrenceBeforeCount = whiteRefrenceBeforeCount
        self.takeWhiteRefrenceAfter = takeWhiteRefrenceAfter
        self.whiteRefrenceAfterCount = whiteRefrenceAfterCount
        self.whiteRefrenceBeforeDelay = whiteRefrenceBeforeDelay
        self.whiteRefrenceAfterDelay = whiteRefrenceAfterDelay
        super.init(takeDarkCurrent: takeDarkCurrent, targetCount: targetCount, targetDelay: targetDelay, takeWhiteRefrenceBefore: takeWhiteRefrenceBefore)
    }
}
