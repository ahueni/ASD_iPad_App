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
        if FileManager.default.fileExists(atPath: self.path, isDirectory: &isDir) {
            return isDir.boolValue
        }
        return false
    }
    
}
