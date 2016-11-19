//
//  Version.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

// V
class Version: SimpleBaseSpectrum {
    
    static let SIZE: Int = 50
    
    let version: String
    let versionNumber: Double
    let type: InstrumentTypes
    
    init(header: HeaderValues, error: ErrorCodes,version: String, versionNumber: Double, type: InstrumentTypes) {
        self.version = version
        self.versionNumber = versionNumber
        self.type = type
        super.init(header: header, error: error)
    }
    
}
