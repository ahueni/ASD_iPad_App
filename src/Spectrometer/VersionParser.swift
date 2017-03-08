//
//  VersionParser.swift
//  Spectrometer
//
//  Created by raphi on 19.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

class VersionParser: BaseSpectrumInput, ISpectrumParser {
    
    typealias T = Version
    
    func parse() throws -> T {
        
        if self.data.count < T.SIZE {
            throw ParsingError(message: "Response is too short, could not parse version.")
        }
        
        let header: Int = getNextInt()
        let error: Int = getNextInt()
        let versionString: String = getNextString(size: 30)
        let versionNumber: Double = getNextDouble()
        let type: Int = getNextInt()
        
        return Version(header: HeaderValues(rawValue: header)!, error: ErrorCodes(rawValue: error)!, version: versionString, versionNumber: versionNumber, type: InstrumentTypes(rawValue: type)!)
    }
    
}
