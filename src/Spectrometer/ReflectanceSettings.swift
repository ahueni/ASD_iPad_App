//
//  ReflectanceSettings.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 14.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class ReflectanceSettings : BaseModeSettings{
    
    required init(coder decoder: NSCoder) {
        self.takeWhiteRefrenceBefore = decoder.decodeBool(forKey: "takeWhiteRefrenceBefore")
        super.init(coder: decoder)
    }
    
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.takeWhiteRefrenceBefore, forKey: "takeWhiteRefrenceBefore")
    }
    
    var takeWhiteRefrenceBefore: Bool
    
    init(targetCount: Int, targetDelay: Int, takeWhiteRefrenceBefore: Bool) {
        self.takeWhiteRefrenceBefore = takeWhiteRefrenceBefore
        super.init(targetCount: targetCount, targetDelay: targetDelay)
    }
}
