//
//  InstrumentSettingsCache.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 25.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class InstrumentStore {
    
    // prevent other instances of this class -> singelton
    private init() { }
    
    static let sharedInstance = InstrumentStore()
    
    // measurements root folder
    let measurementsRoot: URL = FileManager.default.getMeasurmentRoot().appendingPathComponent("Measurements", isDirectory: true)
    
    // Inbox root folder
    let inboxRoot: URL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL).appendingPathComponent("Inbox", isDirectory: true)
    
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
    
    // the actual selected foreoptic file, is there a new one all the radiance pre-calculated values
    // have to be recalculated
    var selectedForeOptic: CalibrationFile?


}
