//
//  SpectrumParser.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

class SpectrumParser {
    
    var data: [UInt8] = []
    var parseIndex: Int = 0
    
    func parseVersion(data: [UInt8]) -> Version {
        
        if data.count < Version.SIZE {
            fatalError("return data ist too small, parsing not possible")
        }
        
        self.data = data
        self.parseIndex = 0
        
        let header: Int = getNextInt()
        let error: Int = getNextInt()
        let versionString: String = getNextString(size: 30)
        let versionNumber: Double = getNextDouble()
        let type: Int = getNextInt()
        
        return Version(header: header, error: error, version: versionString, versionNumber: versionNumber, type: type)
    }
    
    private func getNextInt() -> Int {
        
        let byte1: UInt8 = self.data[parseIndex]
        let byte2: UInt8 = self.data[parseIndex+1]
        let byte3: UInt8 = self.data[parseIndex+2]
        let byte4: UInt8 = self.data[parseIndex+3]
        
        let tempArray:[UInt8] = [byte1, byte2, byte3, byte4]
        let bigEndianValue = tempArray.withUnsafeBufferPointer {
            ($0.baseAddress!.withMemoryRebound(to: Int32.self, capacity: 1) { $0 })
            }.pointee
        
        let value:Int32 = Int32(bigEndian: bigEndianValue)
        
        parseIndex += 4
        return Int(value)
    }
    
    private func getNextDouble() -> Double {
        
        parseIndex += 8
        return 4.234
    }
    
    private func getNextString(size: Int) -> String {
        
        var string = ""
        var count:Int = 0
        
        while count < size {
            let byteValue = self.data[parseIndex+count]
            let scalar = UnicodeScalar.init(byteValue)
            let char = Character.init(scalar)
            string.append(char)
            count += 1;
        }
        
        self.parseIndex += size
        return string
    }
    
}
