//
//  ParameterParser.swift
//  Spectrometer
//
//  Created by raphi on 17.12.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

class ParameterParser: BaseSpectrumInput {
    
    func parse() -> Parameter {
        
        if self.data.count < Parameter.SIZE {
            fatalError("return data ist too small, parsing not possible")
        }
        
        let header: Int = getNextInt() // 4
        let error: Int = getNextInt()  // 8
        let string: String = getNextString(size: 30) // 38
        let value: Double = getNextDoubleReverse() // 46
        let count: Int = getNextInt() // 50
        
        return Parameter(header: header, errbyte: error, name: string, value: value, count: count)
    }
    
}
