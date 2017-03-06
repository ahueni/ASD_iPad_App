//
//  SpectralFileParser.swift
//  Spectrometer
//
//  Created by raphi on 03.12.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

class IndicoIniFileReader: BaseSpectrumInput {
    
    
    func parse() throws -> IndicoFileBase {
        
        spectralFile.fileVersion = getNextString(size: 3)
        spectralFile.comments = getNextString(size: 157)
        spectralFile.savedAt = Date()
        parseIndex += 18 // skip saved At
        spectralFile.programVersion = getVersionFromNextByte()
        spectralFile.fileFormatVersion = getVersionFromNextByte()
        spectralFile.oldIntegrationTime = getNextByte()
        spectralFile.dcCorrected = getNextBool()
        spectralFile.dcTime = getNextUInt32()
        spectralFile.dataType = DataType(rawValue: getNextByte())!
        spectralFile.refTime = getNextUInt32()
        spectralFile.startingWaveLength = getNextFloat()
        spectralFile.waveLengthStep = getNextFloat()
        spectralFile.spectrumDataFormat = DataFormat(rawValue: getNextByte())!
        spectralFile.oldDcCount = getNextByte()
        spectralFile.oldRefCount = getNextByte()
        spectralFile.oldSampleCount = getNextByte()
        spectralFile.application = getNextByte()
        spectralFile.channels = getNextUInt16()
        
        parseIndex += 128 // skip APP_DATA
        parseIndex += 56 // skip GPS_DATA
        
        spectralFile.integrationTime = getNextUInt32()
        spectralFile.fo = Int16(getNextUInt16())
        spectralFile.darkCurrentCorrection = Int16(getNextUInt16())
        spectralFile.calibrationSeries = getNextUInt16()
        spectralFile.instrumentNumber = getNextUInt16()
        
        spectralFile.yMin = getNextFloat()
        spectralFile.yMax = getNextFloat()
        spectralFile.xMin = getNextFloat()
        spectralFile.xMax = getNextFloat()
        
        spectralFile.instrumentRange = getNextUInt16()
        
        print("AxisMode: "+getNextByte().description)//spectralFile.axisMode
        
        spectralFile.flags.append(getNextByte())
        spectralFile.flags.append(getNextByte())
        spectralFile.flags.append(getNextByte())
        spectralFile.flags.append(getNextByte())
        
        spectralFile.dcCount = getNextUInt16()
        spectralFile.refCount = getNextUInt16()
        spectralFile.sampleCount = getNextUInt16()
        
        spectralFile.instrumentType = InstrumentType(rawValue: getNextByte())!
        
        spectralFile.bulbId = getNextUInt32()
        
        spectralFile.swir1Gain = getNextUInt16()
        spectralFile.swir2Gain = getNextUInt16()
        spectralFile.swir1Offset = getNextUInt16()
        spectralFile.swir2Offset = getNextUInt16()
        
        spectralFile.splice1WaveLength = getNextFloat()
        spectralFile.splice2WaveLength = getNextFloat()
        
        parseIndex += 32 // skip rest of header and jump to spectrum
        
        // parse spectral data
        // the type of spectral data is defined in 'spectralFile.dataType' and the format in 'spectralFile.spectrumDataFormat'
        let channels: Int = Int(spectralFile.channels)
        
        switch spectralFile.spectrumDataFormat {
        case .DoubleFormat:
            spectralFile.spectrum = parseDoubleSpectralData(channelCount: channels)
            break
        case .FloatFormat:
            spectralFile.spectrum = parseFloatSpectralData(channelCount: channels)
            break
        case .IntegerFormat:
            spectralFile.spectrum = parseIntegerSpectralData(channelCount: channels)
            break
        default:
            throw ParsingError(message: "Unbekanntes Datenformat der Spektraldaten.")
        }
        
        return spectralFile
    }
    
}
