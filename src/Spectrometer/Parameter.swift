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
    
    static let SIZE: Int = 50
    
    var header: Int
    var errbyte: Int
    var name: String
    var value: Double
    var count: Int
    
}
