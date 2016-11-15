//
//  Init.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

// ERASE - RESTORE - SAVE
struct Init {
    var header: Int
    var errbyte: Int
    var name: [[String]]
    var values: [Double]
    var count: Int
}
