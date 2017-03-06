//
//  SpectralFile.swift
//  Spectrometer
//
//  Created by raphi on 02.12.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

class IndicoFile7 : IndicoFileBase {
    

     /*
     // MARK: Spectral File Header V8 -> special only for V8 files
     var smartDetectorType: Float // 27bytes ?!?
     var reservedBytes: UInt8 = 5
     */
    
    // MARK: Reference File Header
    var ReferenceFlag: Bool = false // why 2bytes?
    var ReferenceTime: Date = Date() // 8 Bytes
    var SpectrumTime: Date = Date() // 8 Bytes
    var SpectrumDescription: String = "" //size ?!?
    
    // MARK: Reference Spectral Data
    var reference: [Double] = []
 
 
     // MARK: Classifier Data
     var yCode: ClassifierType = .Camoclassify
     var yModelType: UInt8 = 0
     var sTitle: String = ""
     var sSubTitle: String = ""
     var sProductName: String = ""
     var sVendor: String = ""
     var sLotNumber: String = ""
     var sSample: String = ""
     var sModelName: String = ""
     var sOperator: String = ""
     var sDateTime: String = ""
     var sInstrument: String = ""
     var sSerialNumber: String = ""
     var sDisplayMode: String = ""
     var sComments: String = ""
     var sUnits: String = ""
     var sFilename: String = ""
     var sUserName: String = ""
     var sReserved1: String = ""
     var sReserved2: String = ""
     var sReserved3: String = ""
     var sReserved4: String = ""
    
     var constituentCount: UInt16 = 0
     var actConstituent: [ConstituentType] = []
    
     // MARK: Dependent Variables
     var SaveDependentVariables: Bool = false
     var DependentVariableCount: UInt16 = 0
     var DependentVariableLabels: String = ""
     var DependentVariables: Float = 0
     
     // MARK: Calibration Header
     var calibrationCount: UInt8 = 0
    
    
     var calibrationBuffer:[CalibrationBuffer] = []
     
     // MARK: Base Calibration Data
     var baseCalibrationData: [Double] = []
     
     // MARK: Lamp Calibration Data
     var lampCalibrationData: [Double] = []
     
     // MARK: Fiber Optic Data
     var fiberOpticData: [Double] = []
    
}

class ConstituentType {
    
    var Name: String = ""
    var PassFail: String = ""
    var mDistance: Double = 0
    var mDistanceLimit: Double = 0
    var Concentration: Double = 0
    var ConcentrationLimit: Double = 0
    var fRatio: Double = 0
    var Residual: Double = 0
    var ResidualLimit: Double = 0
    var Scores: Double = 0
    var ScoresLimit: Double = 0
    var ModelType: Int32 = 0
    
    var reservedBytes: UInt8 = 16
    
}

class CalibrationBuffer {
    
    var calibrationType: CalibrationType = .UnknownFile
    var fileName: String = "" // 20 bytes
    var integrationTime: UInt32 = 0
    var swir1Gain: UInt16 = 0
    var swir2Gain: UInt16 = 0
    
}
