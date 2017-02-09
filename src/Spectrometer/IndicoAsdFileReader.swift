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
        spectralFile = SpectralFileV8()
    }
    
    override func parse() throws -> SpectralFileV8 {
        
        let spectralFileV8 : SpectralFileV8 = try super.parse() as! SpectralFileV8
        
        // MARK: Classifier Data
        spectralFileV8.yCode = ClassifierType(rawValue: getNextByte())!
        spectralFileV8.yModelType = getNextByte()
        spectralFileV8.sTitle = getNextString()
        spectralFileV8.sSubTitle = getNextString()
        spectralFileV8.sProductName = getNextString()
        spectralFileV8.sVendor = getNextString()
        spectralFileV8.sLotNumber = getNextString()
        spectralFileV8.sSample = getNextString()
        spectralFileV8.sModelName = getNextString()
        spectralFileV8.sOperator = getNextString()
        spectralFileV8.sDateTime = getNextString()
        spectralFileV8.sInstrument = getNextString()
        spectralFileV8.sSerialNumber = getNextString()
        spectralFileV8.sDisplayMode = getNextString()
        spectralFileV8.sComments = getNextString()
        spectralFileV8.sUnits = getNextString()
        spectralFileV8.sFilename = getNextString()
        spectralFileV8.sUserName = getNextString()
        spectralFileV8.sReserved1 = getNextString()
        spectralFileV8.sReserved2 = getNextString()
        spectralFileV8.sReserved3 = getNextString()
        spectralFileV8.sReserved4 = getNextString()
        spectralFileV8.constituentCount = getNextUInt16()
        
        spectralFileV8.actConstituent.Name = getNextString()
        spectralFileV8.actConstituent.PassFail = getNextString()
        spectralFileV8.actConstituent.mDistance = getNextDouble()
        spectralFileV8.actConstituent.mDistanceLimit = getNextDouble()
        spectralFileV8.actConstituent.Concentration = getNextDouble()
        spectralFileV8.actConstituent.ConcentrationLimit = getNextDouble()
        spectralFileV8.actConstituent.fRatio = getNextDouble()
        spectralFileV8.actConstituent.Residual = getNextDouble()
        spectralFileV8.actConstituent.ResidualLimit = getNextDouble()
        spectralFileV8.actConstituent.Scores = getNextDouble()
        spectralFileV8.actConstituent.ScoresLimit = getNextDouble()
        spectralFileV8.actConstituent.ModelType = Int32(getNextInt())
        
        // jump over reserved bytes
        parseIndex += 16
        
        // MARK: Dependent Variables
        spectralFileV8.SaveDependentVariables = getNextBool()
        spectralFileV8.DependentVariableCount = getNextUInt16()
        spectralFileV8.DependentVariableLabels = getNextString()
        spectralFileV8.DependentVariables = getNextFloat()
        
        //....
        return spectralFileV8
    }
}
