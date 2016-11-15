//
//  VnirHeader.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

struct VnirHeader {
    var integrationTime: Int
    var scans: Int
    var maxChannel: Int
    var minChannel: Int
    var saturation: Saturation
    var shutter: ShutterStatus
    var drift: Int
    var darkSubtracted: DarkSubtracted
    var reserved: [Int]
}
