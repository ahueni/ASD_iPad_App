//
//  Extensions.swift
//  Spectrometer
//
//  Created by raphi on 19.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

extension FloatingPoint {
    
    init?(_ bytes: [UInt8]) {
        guard bytes.count == MemoryLayout<Self>.size else { return nil }
        self = bytes.withUnsafeBytes {
            return $0.load(fromByteOffset: 0, as: Self.self)
        }
    }
    
}

extension URL {
    
    func exists() -> Bool {
        return FileManager.default.fileExists(atPath: self.path)
    }
    
    func isDirectory() -> Bool {
        var isDir: ObjCBool = false
        if FileManager.default.fileExists(atPath: self.path, isDirectory: &isDir) {
            return isDir.boolValue
        }
        return false
    }
    
}

extension TimeInterval {
    
    // converts an int value to a 00:00:00 string
    func getHHMMSS() -> String {
        let intValue = Int(self)
        let t = (intValue / 3600, (intValue % 3600) / 60, (intValue % 3600) % 60)
        return String(format: "%02i:%02i:%02i", t.0, t.1, t.2)
    }
    
}

extension Float {
    
    func readableMilis() -> String {
        
        let ms = Int(self)
        
        if (ms < 1000) {
            return "\(ms) ms"
        } else if (ms < 60000) {
            let s = Float(ms) / Float(1000)
            return "\(s) sec"
        } else if (ms < 3600000) {
            let m = Float(ms) / Float(60000)
            return "\(m) min"
        } else {
            let h = Float(ms) / Float(3600000)
            return "\(h) h"
        }
    }
    
}
 
