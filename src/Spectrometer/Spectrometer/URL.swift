//
//  URL.swift
//  Spectrometer
//
//  Created by raphi on 20.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

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
    
    func getDisplayPathFromRoot(rootPath: URL) -> String {
        return self.pathComponents[rootPath.pathComponents.count-1...(self.pathComponents.count)-1].joined(separator: "/")
    }
    
}
