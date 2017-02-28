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
    var measurmentMode: MeasurementMode
    var path: URL
    
    required init(coder decoder: NSCoder) {
        self.fileName = decoder.decodeObject(forKey: "fileName") as! String
        self.measurmentMode = MeasurementMode(rawValue: Int(decoder.decodeInt32(forKey: "measurmentMode")))!
        
        let pathString = decoder.decodeObject(forKey: "pathString") as! String
        self.path = URL(string: pathString)!
        
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.fileName, forKey: "fileName")
        aCoder.encode(self.path.relativePath, forKey: "pathString")
        aCoder.encode(self.measurmentMode.rawValue, forKey: "measurmentMode")
    }
    
    init(fileName: String, path: URL, measurmentMode : MeasurementMode){
        self.fileName = fileName
        self.measurmentMode = measurmentMode
        self.path = path
    }
}

enum MeasurementMode : Int{
    case Raw
    case Reflectance
    case Radiance
}
