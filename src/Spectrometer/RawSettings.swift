//
//  RawSettings.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 14.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class RawSettings : BaseMeasurementModeSettings
{
    required init(coder decoder: NSCoder) {
    self.takeDarkCurrent = decoder.decodeBool(forKey: "takeDarkCurrent")
        super.init(coder: decoder)
    }
    
    public override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(self.takeDarkCurrent, forKey: "takeDarkCurrent")
    }
    
    var takeDarkCurrent: Bool
    
    init(takeDarkCurrent: Bool, targetCount: Int, targetDelay: Int) {
        self.takeDarkCurrent = takeDarkCurrent
        super.init(targetCount: targetCount, targetDelay: targetDelay)
    }
}
