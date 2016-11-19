//
//  Init.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

// ERASE - RESTORE - SAVE
class Init: SimpleBaseSpectrum {
    
    static let SIZE: Int = 50
    
    let name: [[String]]
    let values: [Double]
    let count: Int
    
    init(header: Int, error: Int, name: [[String]], values:[Double], count: Int) {
        
        self.name = name
        self.values = values
        self.count = count
        
        super.init(header: HeaderValues(rawValue: header)!, error: ErrorCodes(rawValue: error)!)
    }
    
}
