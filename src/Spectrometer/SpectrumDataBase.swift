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
    
    init(header: HeaderValues, error: ErrorCodes) {
        self.header = header
        self.error = error
    }
    
}
