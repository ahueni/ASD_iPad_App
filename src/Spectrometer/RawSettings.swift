//
//  RawSettings.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 14.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class RawSettings : NSObject, NSCoding {
    
    required init(coder decoder: NSCoder) {
        self.takeDarkCurrent = decoder.decodeBool(forKey: "takeDarkCurrent")
        self.targetCount = Int(decoder.decodeInt32(forKey: "targetCount"))
        self.targetDelay = Int(decoder.decodeInt32(forKey: "targetDelay"))
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.takeDarkCurrent, forKey: "takeDarkCurrent")
        aCoder.encode(self.targetCount, forKey: "targetCount")
        aCoder.encode(self.targetDelay, forKey: "targetDelay")
    }

    var takeDarkCurrent: Bool
    var targetCount: Int
    var targetDelay: Int
    
    init(takeDarkCurrent: Bool, targetCount: Int, targetDelay: Int) {
        self.takeDarkCurrent = takeDarkCurrent
        self.targetCount = targetCount
        self.targetDelay = targetDelay
    }
}
