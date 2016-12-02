//
//  CalibrationBuffer.swift
//  Spectrometer
//
//  Created by raphi on 02.12.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

struct CalibrationBuffer {
    
    var calibrationType: CalibrationType
    var fileName: String // 20 bytes
    var integrationTime: UInt32
    var swir1Gain: UInt16
    var swir2Gain: UInt16
    
}

enum CalibrationType: UInt8 {
    
    case AbsoluteReflectanceFile = 0
    case BaseFile = 1
    case LampFile = 2
    case FiberOpticFile = 3
    
}
