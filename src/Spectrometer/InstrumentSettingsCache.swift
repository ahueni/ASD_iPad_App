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
    
    // indicators to stopp or check a loop in background threads -> they have to be in a singelton
    var aquireLoop = false
    var cancelMeasurment = true
    
    // instrument configuration file all informations like ip, port, base-file, lamp-file and foreoptics
    var instrumentConfiguration: SpectrometerConfig!
    
    // all wavelength values of FS3 and FS4 devices
    // they will be read and set at startup (initialize)
    var startingWaveLength: Int!
    var endingWaveLength: Int!
    var vinirStartingWavelength: Int!
    var vinirEndingWavelength: Int!
    var s1StartingWavelength: Int!
    var s1EndingWavelength: Int!
    var s2StartingWavelength: Int!
    var s2EndingWavelength: Int!
    
    // its needed to calculate dark current -> set at initialization
    var vinirDarkCurrentCorrection: Double!
    
    // if darkCurrent is taken its saved here applicationwide
    var darkCurrent: FullRangeInterpolatedSpectrum?
    
    // timer objects for dark current and white reference
    private var darkCurrentTimer:Timer?
    var darkCurrentStartTime: TimeInterval?
    
    private var whiteReferenceTimer: Timer?
    var whiteReferenceStartTime: TimeInterval?
    
    // the actual selected foreoptic file, is there a new one all the radiance pre-calculated values
    // have to be recalculated
    var selectedForeOptic: CalibrationFile?
    
    func restartDarkCurrentTimer() -> Void {
        
        if let actualDarkCurrentTimer = darkCurrentTimer {
            actualDarkCurrentTimer.invalidate()
        }
        
        darkCurrentStartTime = NSDate.timeIntervalSinceReferenceDate
        darkCurrentTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in
            NotificationCenter.default.post(name: .darkCurrentTimer, object: nil)
        })
        
    }
    
    func restartWhiteReferenceTimer() -> Void {
        
        if let actualWhiteReferenceTimer = whiteReferenceTimer {
            actualWhiteReferenceTimer.invalidate()
        }
        
        whiteReferenceStartTime = NSDate.timeIntervalSinceReferenceDate
        whiteReferenceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in
            NotificationCenter.default.post(name: .whiteReferenceTimer, object: nil)
        })
        
    }
    
    // prevent other instances of this class -> singelton
    private init() {
        
    }

}
