//
//  IndicoAsdFileReader.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 09.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class IndicoAsdFileReader : IndicoIniFileReader  {
    
    override init(data: [UInt8]) {
        super.init(data: data)
        spectralFile = IndicoFile7()
    }
    
    override func parse() throws -> IndicoFile7 {
        
        let spectralFileV8 : IndicoFile7 = try super.parse() as! IndicoFile7
        
        spectralFileV8.ReferenceFlag = getNextBoolFrom2Bytes()
        
        parseIndex += 8 //spectralFile.ReferenceTime = Date()
        parseIndex += 8 //spectralFile.SpectrumTime = Date()
        
        // take spectralFile comment as prefixedString
        spectralFileV8.SpectrumDescription = getNextPrefixedString()
        
        // parse reference data
        switch spectralFile.spectrumDataFormat {
        case .DoubleFormat:
            spectralFileV8.reference = parseDoubleSpectralData(channelCount: Int(spectralFileV8.channels))
            break
        case .FloatFormat:
            spectralFileV8.reference = parseFloatSpectralData(channelCount: Int(spectralFileV8.channels))
            break
        case .IntegerFormat:
            spectralFileV8.reference = parseIntegerSpectralData(channelCount: Int(spectralFileV8.channels))
            break
        default:
            throw ParsingError(message: "Unbekanntes Datenformat der Referenzdaten.")
        }
        
        // MARK: Classifier Data
        spectralFileV8.yCode = ClassifierType(rawValue: getNextByte())!
        spectralFileV8.yModelType = getNextByte()
        
        spectralFileV8.sTitle = getNextPrefixedString()
        spectralFileV8.sSubTitle = getNextPrefixedString()
        spectralFileV8.sProductName = getNextPrefixedString()
        spectralFileV8.sVendor = getNextPrefixedString()
        spectralFileV8.sLotNumber = getNextPrefixedString()
        spectralFileV8.sSample = getNextPrefixedString()
        spectralFileV8.sModelName = getNextPrefixedString()
        spectralFileV8.sOperator = getNextPrefixedString()
        spectralFileV8.sDateTime = getNextPrefixedString()
        spectralFileV8.sInstrument = getNextPrefixedString()
        spectralFileV8.sSerialNumber = getNextPrefixedString()
        spectralFileV8.sDisplayMode = getNextPrefixedString()
        spectralFileV8.sComments = getNextPrefixedString()
        spectralFileV8.sUnits = getNextPrefixedString()
        spectralFileV8.sFilename = getNextPrefixedString()
        spectralFileV8.sUserName = getNextPrefixedString()
        spectralFileV8.sReserved1 = getNextPrefixedString()
        spectralFileV8.sReserved2 = getNextPrefixedString()
        spectralFileV8.sReserved3 = getNextPrefixedString()
        spectralFileV8.sReserved4 = getNextPrefixedString()
        
        spectralFileV8.constituentCount = getNextUInt16()
        
        for _ in 0..<spectralFileV8.constituentCount {
            let const:ConstituentType = ConstituentType()
            const.Name = getNextString()
            const.PassFail = getNextString()
            const.mDistance = getNextDouble()
            const.mDistanceLimit = getNextDouble()
            const.Concentration = getNextDouble()
            const.ConcentrationLimit = getNextDouble()
            const.fRatio = getNextDouble()
            const.Residual = getNextDouble()
            const.ResidualLimit = getNextDouble()
            const.Scores = getNextDouble()
            const.ScoresLimit = getNextDouble()
            const.ModelType = Int32(getNextInt())
            spectralFileV8.actConstituent.append(const)
            // jump over reserved bytes
            parseIndex += 16
        }
        
        // MARK: Dependent Variables
        spectralFileV8.SaveDependentVariables = getNextBool()
        spectralFileV8.DependentVariableCount = getNextUInt16()
        parseIndex += 1 // random, educated skip
        spectralFileV8.DependentVariableLabels = getNextPrefixedString()
        spectralFileV8.DependentVariables = getNextFloat()
        
        // MARK: Calibration Header
        spectralFileV8.calibrationCount = getNextByte()
        
        for _ in 0..<spectralFileV8.calibrationCount {
            let calibrationBuffer = CalibrationBuffer()
            calibrationBuffer.calibrationType = CalibrationType(rawValue: getNextByte())!
            calibrationBuffer.fileName = getNextString(size: 20)
            calibrationBuffer.integrationTime = getNextUInt32()
            calibrationBuffer.swir1Gain = getNextUInt16()
            calibrationBuffer.swir2Gain = getNextUInt16()
            spectralFileV8.calibrationBuffer.append(calibrationBuffer)
        }
        
        if (spectralFileV8.calibrationCount != 0) {
            
            // MARK: Base Calibration Data
            spectralFileV8.baseCalibrationData = parseDoubleSpectralData(channelCount: Int(spectralFileV8.channels))
            
            // MARK: Lamp Calibration Data
            spectralFileV8.lampCalibrationData = parseDoubleSpectralData(channelCount: Int(spectralFileV8.channels))
            
            // MARK: Fiber Optic Data
            spectralFileV8.fiberOpticData = parseDoubleSpectralData(channelCount: Int(spectralFileV8.channels))
            
        }
        
        return spectralFileV8
    }
}
