//
//  FullRangeInterpolatedSpectrum.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

class FullRangeInterpolatedSpectrum : BaseSpectrum {
    
    var spectrumHeader: SpectrumHeader
    var spectrumBuffer: [Float]
    
    init(spectrumHeader: SpectrumHeader, spectrumBuffer: [Float]) {
        self.spectrumHeader = spectrumHeader
        self.spectrumBuffer = spectrumBuffer
    }
    
}
