//
//  SpectralFileParser.swift
//  Spectrometer
//
//  Created by raphi on 03.12.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

class SpectralFileParser: BaseSpectrumParser {
    
    func parse() -> SpectralFileBase {
        
        let spectralFile = SpectralFileV7()
        spectralFile.fileVersion = getNextString(size: 3)
        spectralFile.comments = getNextString(size: 157)
        spectralFile.savedAt = Date()
        return spectralFile
        
    }
    
}
