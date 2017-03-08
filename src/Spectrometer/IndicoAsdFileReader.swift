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
    
    override func parse() throws -> T {
        
        let spectralFile7 = try super.parse() as! IndicoFile7
        
        spectralFile7.ReferenceFlag = getNextBoolFrom2Bytes()
        
        parseIndex += 8 //spectralFile.ReferenceTime = Date()
        parseIndex += 8 //spectralFile.SpectrumTime = Date()
        
        // take spectralFile comment as prefixedString
        spectralFile7.SpectrumDescription = getNextPrefixedString()
        
        // parse reference data
        switch spectralFile7.spectrumDataFormat {
        case .DoubleFormat:
            spectralFile7.reference = parseDoubleSpectralData(channelCount: Int(spectralFile7.channels))
            break
        case .FloatFormat:
            spectralFile7.reference = parseFloatSpectralData(channelCount: Int(spectralFile7.channels))
            break
        case .IntegerFormat:
            spectralFile7.reference = parseIntegerSpectralData(channelCount: Int(spectralFile7.channels))
            break
        default:
            throw ParsingError(message: "Unbekanntes Datenformat der Referenzdaten.")
        }
        
        // MARK: Classifier Data
        spectralFile7.yCode = ClassifierType(rawValue: getNextByte())!
        spectralFile7.yModelType = getNextByte()
        
        spectralFile7.sTitle = getNextPrefixedString()
        spectralFile7.sSubTitle = getNextPrefixedString()
        spectralFile7.sProductName = getNextPrefixedString()
        spectralFile7.sVendor = getNextPrefixedString()
        spectralFile7.sLotNumber = getNextPrefixedString()
        spectralFile7.sSample = getNextPrefixedString()
        spectralFile7.sModelName = getNextPrefixedString()
        spectralFile7.sOperator = getNextPrefixedString()
        spectralFile7.sDateTime = getNextPrefixedString()
        spectralFile7.sInstrument = getNextPrefixedString()
        spectralFile7.sSerialNumber = getNextPrefixedString()
        spectralFile7.sDisplayMode = getNextPrefixedString()
        spectralFile7.sComments = getNextPrefixedString()
        spectralFile7.sUnits = getNextPrefixedString()
        spectralFile7.sFilename = getNextPrefixedString()
        spectralFile7.sUserName = getNextPrefixedString()
        spectralFile7.sReserved1 = getNextPrefixedString()
        spectralFile7.sReserved2 = getNextPrefixedString()
        spectralFile7.sReserved3 = getNextPrefixedString()
        spectralFile7.sReserved4 = getNextPrefixedString()
        
        spectralFile7.constituentCount = getNextUInt16()
        
        for _ in 0..<spectralFile7.constituentCount {
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
            spectralFile7.actConstituent.append(const)
            // jump over reserved bytes
            parseIndex += 16
        }
        
        // MARK: Dependent Variables
        spectralFile7.SaveDependentVariables = getNextBool()
        spectralFile7.DependentVariableCount = getNextUInt16()
        parseIndex += 1 // random, educated skip
        spectralFile7.DependentVariableLabels = getNextPrefixedString()
        spectralFile7.DependentVariables = getNextFloat()
        
        // MARK: Calibration Header
        spectralFile7.calibrationCount = getNextByte()
        
        for _ in 0..<spectralFile7.calibrationCount {
            let calibrationBuffer = CalibrationBuffer()
            calibrationBuffer.calibrationType = CalibrationType(rawValue: getNextByte())!
            calibrationBuffer.fileName = getNextString(size: 20)
            calibrationBuffer.integrationTime = getNextUInt32()
            calibrationBuffer.swir1Gain = getNextUInt16()
            calibrationBuffer.swir2Gain = getNextUInt16()
            spectralFile7.calibrationBuffer.append(calibrationBuffer)
        }
        
        if (spectralFile7.calibrationCount != 0) {
            
            // MARK: Base Calibration Data
            spectralFile7.baseCalibrationData = parseDoubleSpectralData(channelCount: Int(spectralFile7.channels))
            
            // MARK: Lamp Calibration Data
            spectralFile7.lampCalibrationData = parseDoubleSpectralData(channelCount: Int(spectralFile7.channels))
            
            // MARK: Fiber Optic Data
            spectralFile7.fiberOpticData = parseDoubleSpectralData(channelCount: Int(spectralFile7.channels))
            
        }
        
        return spectralFile7
    }
}
