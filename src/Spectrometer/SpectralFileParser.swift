//
//  SpectralFileParser.swift
//  Spectrometer
//
//  Created by raphi on 03.12.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

class SpectralFileParser: BaseSpectrumParser {
    
    let spectralFile = SpectralFileV8()
    
    func parse() throws -> SpectralFileBase {
        
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
            parseDoubleSpectralData(channelCount: channels)
            break
        case .FloatFormat:
            parseFloatSpectralData(channelCount: channels)
            break
        case .IntegerFormat:
            parseIntegerSpectralData(channelCount: channels)
            break
        default:
            throw ParsingError(message: "Unbekanntes Datenformat der Spektraldaten.")
        }
        
        // special case for config reference files
        // they have a special format without a reference
        if (spectralFile.fileFormatVersion < 7) {
            return spectralFile
        }
        
        spectralFile.ReferenceFlag = getNextBoolFrom2Bytes()
        parseIndex += 8 //spectralFile.ReferenceTime = Date()
        parseIndex += 8 //spectralFile.SpectrumTime = Date()
        spectralFile.SpectrumDescription = getNextString()
        
        // parse reference data
        switch spectralFile.spectrumDataFormat {
        case .DoubleFormat:
            parseDoubleSpectralData(channelCount: channels)
            break
        case .FloatFormat:
            parseFloatSpectralData(channelCount: channels)
            break
        case .IntegerFormat:
            parseIntegerSpectralData(channelCount: channels)
            break
        default:
            throw ParsingError(message: "Unbekanntes Datenformat der Referenzdaten.")
        }
        
        // TODO: Parsing rest of file -> is it necessary for our project?
        
        return spectralFile
        
    }
    
    private func parseDoubleSpectralData(channelCount: Int) -> Void {
        
        for i in 0...channelCount-1 {
            let wavelength = i + Int(spectralFile.startingWaveLength)
            let value = getNextDouble()
            spectralFile.spectrum.append(value)
            print(wavelength.description + " / " + value.description)
        }
        
    }
    
    private func parseFloatSpectralData(channelCount: Int) -> Void {
        
        for i in 0...channelCount-1 {
            let wavelength = i + Int(spectralFile.startingWaveLength)
            let value = getNextFloat()
            spectralFile.spectrum.append(Double(value))
            print(wavelength.description + " / " + value.description)
        }
        
    }
    
    private func parseIntegerSpectralData(channelCount: Int) -> Void {
        
        for i in 0...channelCount-1 {
            let wavelength = i + Int(spectralFile.startingWaveLength)
            let value = getNextInt()
            spectralFile.spectrum.append(Double(value))
            print(wavelength.description + " / " + value.description)
        }
        
    }
    
}
