//
//  Extensions.swift
//  Spectrometer
//
//  Created by raphi on 19.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

extension Int {
    init(_ bool:Bool) {
        self = bool ? 1 : 0
    }
}

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

extension Date
{
    func second() -> Int
    {
        let calendar = NSCalendar.current
        return calendar.component(.second, from: self)
    }
    
    func minute() -> Int
    {
        let calendar = NSCalendar.current
        return calendar.component(.minute, from: self)
    }
    
    func hour() -> Int
    {
        let calendar = NSCalendar.current
        return calendar.component(.hour, from: self)
    }
    
    func day() -> Int
    {
        let calendar = NSCalendar.current
        return calendar.component(.day, from: self)
    }
    
    func monthOfYear() -> Int
    {
        let calendar = NSCalendar.current
        return calendar.component(.month, from: self)
    }
    
    // month of year [0,11]
    // swift can't call another extension from within an extension
    func monthOfYearIndico() -> Int
    {
        let calendar = NSCalendar.current
        return calendar.component(.month, from: self) - 1
    }
    
    func yearsSince1900() -> Int
    {
        let calendar = NSCalendar.current
        return calendar.component(.year, from: self) - 1900
    }
    
    func dayOfWeek() -> Int
    {
        let calendar = NSCalendar.current
        return calendar.component(.weekday, from: self)
    }
    
    // day of week [0,6] (Sunday = 0)
    // swift can't call another extension from within an extension
    func dayOfWeekIndico() -> Int{
        let calendar = NSCalendar.current
        return calendar.component(.weekday, from: self) - 1
    }
    
    func dayOfYear() -> Int
    {
        let calendar = NSCalendar.current
        return calendar.ordinality(of: .day, in: .year, for: self)!
    }
    
    
    func isDayLightSavingTime() -> Bool
    {
        let timeZone = NSTimeZone.local
        return timeZone.isDaylightSavingTime(for: self)
    }
}
 
