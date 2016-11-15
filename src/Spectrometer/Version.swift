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
    
    let version: String
    let versionNumber: Double
    let type: Int
    
    init(header: Int, error: Int, version: String, versionNumber: Double, type:Int) {
        self.version = version
        self.versionNumber = versionNumber
        self.type = type
        super.init(header: header, error: error)
    }
    
}
