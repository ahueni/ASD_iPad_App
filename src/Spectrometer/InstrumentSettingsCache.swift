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
    
    var startingWaveLength: Int = 0
    var endingWaveLength: Int = 0
    var vinirStartingWavelength : Int = 0
    var vinirEndingWavelength: Int = 0
    var vinirDarkCurrentCorrection: Double = 0
    
    var darkCurrent: FullRangeInterpolatedSpectrum?
    
    // prevent other instances of this class
    private init() {
    }

}
