//
//  MeasurmentSettings.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 15.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class MeasurmentSettings : NSObject, NSCoding{
    
    var fileName: String
    var path: URL
    var measurmentMode: MeasurmentMode
    
    required init(coder decoder: NSCoder) {
        self.fileName = decoder.decodeObject(forKey: "fileName") as! String
        self.path = decoder.decodeObject(forKey: "path") as! URL
        self.measurmentMode = MeasurmentMode(rawValue: Int(decoder.decodeInt32(forKey: "measurmentMode")))!
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.fileName, forKey: "fileName")
        aCoder.encode(self.path, forKey: "path")
        aCoder.encode(self.measurmentMode.rawValue, forKey: "measurmentMode")
    }
    
    init(fileName : String, path : URL, measurmentMode : MeasurmentMode){
        self.fileName = fileName
        self.path = path
        self.measurmentMode = measurmentMode
    }
}

enum MeasurmentMode : Int{
    case Raw
    case Reflectance
    case Radiance
}
