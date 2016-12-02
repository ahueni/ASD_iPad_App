//
//  SpectrumParser.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

protocol ISpectrumParser {
    
    associatedtype T
    func parse() -> T
    
}

class BaseSpectrumParser {
    
    internal let data: [UInt8]
    internal var parseIndex: Int
    
    init(data: [UInt8]) {
        self.data = data
        parseIndex = 0
    }
    
    internal func getNextInt() -> Int {
        
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
    
    internal func getNextFloat() -> Float {
        var byteArray: [UInt8] = []
        for i in 0...3 {
            byteArray.insert(self.data[parseIndex+i], at: 0)
        }
        let floatValue:Float = Float(byteArray)!
        
        parseIndex += 4
        return floatValue
        
    }
    
    internal func getNextDouble() -> Double {
        
        var byteArray: [UInt8] = []
        for i in 0...7 {
            byteArray.insert(self.data[parseIndex+i], at: 0)
        }
        
        let doubleValue:Double = Double(byteArray)!
        
        parseIndex += 8
        return doubleValue
    }
    
    internal func getNextString(size: Int) -> String {
        
        var string = ""
        var count:Int = 0
        
        while count <= size {
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
