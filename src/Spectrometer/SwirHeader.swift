//
//  SwirHeader.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

struct SwirHeader {
    
    var tecStatus: TecStatus
    var tecCurrent: Int
    var maxChannel: Int
    var minChannel: Int
    var saturation: Saturation
    var AScans: Int
    var BScans: Int
    var darkCurrent: Int
    var gain: Int
    var offset: Int
    var scansize1: Int
    var scansize2: Int
    var darkSubtracted: DarkSubtracted
    
    static let reserve: Int = 3
    
}
