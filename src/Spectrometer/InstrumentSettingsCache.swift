//
//  InstrumentSettingsCache.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 25.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class InstrumentSettingsCache {
    
    static let sharedInstance = InstrumentSettingsCache()
    
    var aquireLoop = false
    
    var startingWaveLength: Int!
    var endingWaveLength: Int!
    var vinirStartingWavelength: Int!
    var vinirEndingWavelength: Int!
    var s1StartingWavelength: Int!
    var s1EndingWavelength: Int!
    var s2StartingWavelength: Int!
    var s2EndingWavelength: Int!
    
    var vinirDarkCurrentCorrection: Double!
    
    var darkCurrent: FullRangeInterpolatedSpectrum?
    
    // prevent other instances of this class
    private init() {
        
    }

}
