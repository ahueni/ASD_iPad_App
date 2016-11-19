//
//  SpectrumHeader.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

struct SpectrumHeader {
    
    var header: HeaderValues
    var error: ErrorCodes
    var sampleCount: Int
    var trigger: Int
    var voltage: Float
    var current: Int
    var temperature: Int
    var motorCurrent: Int
    var instrumentHours: Int
    var instrumentMinutes: Int
    var instrumentType: Int
    var AB: Int
    
    static let reserve: Int = 4
    
    var vHeader: VnirHeader
    var s1Header: SwirHeader
    var s2Header: SwirHeader
}
