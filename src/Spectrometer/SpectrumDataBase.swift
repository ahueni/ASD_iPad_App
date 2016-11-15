//
//  SpectrumDataBase.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

class BaseSpectrum {
    
}

class SimpleBaseSpectrum: BaseSpectrum {
    
    let header: HeaderValues
    let error: ErrorCodes
    
    init(header: Int, error: Int) {
        self.header = HeaderValues(rawValue: header)!
        self.error = ErrorCodes(rawValue: error)!
    }
    
}
