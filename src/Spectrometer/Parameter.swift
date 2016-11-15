//
//  Parameter.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

// ABORT - INIT
struct Parameter {
    var header: Int
    var errbyte: Int
    var name: [String]
    var value: Double
    var count: Int
}
