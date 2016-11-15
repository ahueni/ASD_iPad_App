//
//  SpectrumParser.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

class SpectrumParser {
    
    //func parseFullRangeInterpolatedSpectrum(data: [UInt8]) -> FullRangeInterpolatedSpectrum {
    //}
    
    func parseVersion(data: [UInt8]) -> Version {
        
        let header: Int = getIntFromByteArray(array: data, startIndex: 0)
        let error: Int = getIntFromByteArray(array: data, startIndex: 4)
        
        return Version(header: header, error: error, version: "Version 1.0", versionNumber: 1.0, type: 3)
    }
    
    func getIntFromByteArray(array: [UInt8], startIndex: Int) -> Int {
        
        let byte1: UInt8 = array[startIndex]
        let byte2: UInt8 = array[startIndex+1]
        let byte3: UInt8 = array[startIndex+2]
        let byte4: UInt8 = array[startIndex+3]
        
        
        let data:[UInt8] = [byte1, byte2, byte3, byte4]
    
        
        let bigEndianValue = data.withUnsafeBufferPointer {
            ($0.baseAddress!.withMemoryRebound(to: Int32.self, capacity: 1) { $0 })
            }.pointee
        
        let value:Int32 = Int32(bigEndian: bigEndianValue)
        
        return Int(value)
        
    }
    
}
