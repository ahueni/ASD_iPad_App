//
//  MeasurmentSettings.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 15.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class MeasurmentSettings : NSObject, NSCoding {
    var fileName: String
    var comment: String?
    var measurmentMode: MeasurementMode
    var path: URL
    
    required init(coder decoder: NSCoder) {
        self.fileName = decoder.decodeObject(forKey: "fileName") as! String
        self.comment = decoder.decodeObject(forKey: "comment") as? String
        self.measurmentMode = MeasurementMode(rawValue: decoder.decodeDouble(forKey: "measurmentMode"))!
        let pathString = decoder.decodeObject(forKey: "pathString") as! String
        
        // create url if its possible
        self.path = URL(fileURLWithPath: pathString, isDirectory: true).resolvingSymlinksInPath()
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.fileName, forKey: "fileName")
        aCoder.encode(self.comment, forKey: "comment")
        aCoder.encode(self.path.path, forKey: "pathString")
        aCoder.encode(self.measurmentMode.rawValue, forKey: "measurmentMode")
    }
    
    init(fileName: String, comment: String?, path: URL, measurmentMode : MeasurementMode){
        self.fileName = fileName
        self.comment = comment
        self.measurmentMode = measurmentMode
        self.path = path
    }
}
