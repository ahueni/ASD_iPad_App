//
//  ConstituentType.swift
//  Spectrometer
//
//  Created by raphi on 02.12.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

class ConstituentType {
    
    var Name: String = ""
    var PassFail: String = ""
    var mDistance: Double = 0
    var mDistanceLimit: Double = 0
    var Concentration: Double = 0
    var ConcentrationLimit: Double = 0
    var fRatio: Double = 0
    var Residual: Double = 0
    var ResidualLimit: Double = 0
    var Scores: Double = 0
    var ScoresLimit: Double = 0
    var ModelType: Int32 = 0
    
    var reservedBytes: UInt8 = 16
    
}
