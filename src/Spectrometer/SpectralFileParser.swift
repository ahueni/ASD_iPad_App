//
//  SpectralFileParser.swift
//  Spectrometer
//
//  Created by raphi on 03.12.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

class SpectralFileParser: BaseSpectrumParser {
    
    func parse() -> SpectralFileBase {
        
        let spectralFile = SpectralFileV7()
        spectralFile.fileVersion = getNextString(size: 3)
        spectralFile.comments = getNextString(size: 157)
        spectralFile.savedAt = Date()
        parseIndex += 18
        spectralFile.programVersion = getNextByte()
        spectralFile.fileFormatVersion = getNextByte()
        spectralFile.oldIntegrationTime = getNextByte()
        spectralFile.dcCorrected = getNextBool()
        
        print ("dcTime: " + getNextInt().description)//spectralFile.dcTime = UInt32(getNextInt())
        
        print("DataType: " + getNextByte().description) //spectralFile.dataType = DataType(rawValue: getNextByte())!
        
        spectralFile.refTime = UInt32(getNextInt())
        spectralFile.startingWaveLength = getNextFloat()
        spectralFile.waveLengthStep = getNextFloat()
        spectralFile.spectrumDataFormat = getNextByte()
        spectralFile.oldDcCount = getNextByte()
        spectralFile.oldRefCount = getNextByte()
        spectralFile.oldSampleCount = getNextByte()
        spectralFile.application = getNextByte()
        spectralFile.channels = getNextShortInt()
        
        return spectralFile
        
    }
    
}
