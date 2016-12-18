//
//  ParameterParser.swift
//  Spectrometer
//
//  Created by raphi on 17.12.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

class ParameterParser: BaseSpectrumParser {
    
    func parse() -> Parameter {
        
        if self.data.count < Parameter.SIZE {
            fatalError("return data ist too small, parsing not possible")
        }
        
        let header: Int = getNextInt()
        let error: Int = getNextInt()
        let string: String = getNextString(size: 30)
        let value: Double = getNextDouble()
        let count: Int = getNextInt()
        
        return Parameter(header: header, errbyte: error, name: [string], value: value, count: count)
    }
    
}
