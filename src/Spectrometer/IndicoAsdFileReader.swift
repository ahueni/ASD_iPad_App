//
//  IndicoAsdFileReader.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 09.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class IndicoAsdFileReader : IndicoIniFileReader{
    
    override init(data: [UInt8]) {
        super.init(data: data)
        spectralFile = SpectralFileV8()
    }
    
    override func parse() throws -> SpectralFileV8 {
        
        let spectralFileV8 : SpectralFileV8 = try super.parse() as! SpectralFileV8
        
        
        
        //....
        return spectralFileV8
    }
}
