//
//  CalibrationBuffer.swift
//  Spectrometer
//
//  Created by raphi on 02.12.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

class CalibrationBuffer {
    
    var calibrationType: CalibrationType = .UnknownFile
    var fileName: String = "" // 20 bytes
    var integrationTime: UInt32 = 0
    var swir1Gain: UInt16 = 0
    var swir2Gain: UInt16 = 0
    
}
