//
//  ConstituentType.swift
//  Spectrometer
//
//  Created by raphi on 02.12.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

struct ConstituentType {
    
    var Name: String
    var PassFail: String
    var mDistance: Double
    var mDistanceLimit: Double
    var Concentration: Double
    var ConcentrationLimit: Double
    var fRatio: Double
    var Residual: Double
    var ResidualLimit: Double
    var Scores: Double
    var ScoresLimit: Double
    var ModelType: Int32
    
    var reservedBytes: UInt8 = 16
    
}
