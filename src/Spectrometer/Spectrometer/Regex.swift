//
//  Regex.swift
//  Spectrometer
//
//  Created by raphi on 24.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

class Regex {
    
    static func test() -> Void {
        print("test")
    }
    
    static func valideIp(ip: String?) -> Bool {
        if (ip == nil) { return false }
        do {
            let pattern = "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$"
            let regex = try NSRegularExpression(pattern: pattern)
            let nsString = ip! as NSString
            let results = regex.matches(in: ip!, range: NSRange(location: 0, length: nsString.length))
            return results.count == 1
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return false
        }
    }
    
    static func test2(){
        print ("this is a test")
    }
    
}
