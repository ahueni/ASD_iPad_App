//
//  URL.swift
//  Spectrometer
//
//  Created by raphi on 20.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

extension URL {
    
    func isDirectory() -> Bool {
        var isDir: ObjCBool = false
        FileManager.default.fileExists(atPath: self.path, isDirectory: &isDir)
        let test:Bool = isDir.boolValue
        
        return test
    }
    
}
