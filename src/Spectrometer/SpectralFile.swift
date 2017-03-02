//
//  SpectralFile.swift
//  Spectrometer
//
//  Created by raphi on 02.12.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation
import Charts

class SpectralFileBase {
    
    // MARK: Spectral File Header
    var fileVersion: String = ""
    var comments: String = ""
    var savedAt: Date = Date(timeIntervalSinceNow: TimeInterval(integerLiteral: 12))
    var dayLightSavingFlag: Int = 0
    var programVersion: Double = 0 // stored in upper/lower nibble in 1 byte
    var fileFormatVersion: Double = 0 //  stored in upper/lower nibble in 1 byte
    var oldIntegrationTime: UInt8 = 0
    var dcCorrected: Bool = false
    var dcTime: UInt32 = 0
    var dataType: DataType = DataType.AbsType
    var refTime: UInt32 = 0
    var startingWaveLength: Float = 0.0
    var waveLengthStep: Float = 0.0
    var spectrumDataFormat: DataFormat = DataFormat.UnknownFormat
    var oldDcCount: UInt8 = 0
    var oldRefCount: UInt8 = 0
    var oldSampleCount: UInt8 = 0
    var application: UInt8 = 0
    var channels: UInt16 = 0
    /*var appData: AppData
    var gpsData: GpsData */
    var integrationTime: UInt32 = 0
    var fo: Int16 = 0
    var darkCurrentCorrection: Int16 = 0
    var calibrationSeries: UInt16 = 0
    var instrumentNumber: UInt16 = 0
    var yMin: Float = 0
    var yMax: Float = 0
    var xMin: Float = 0
    var xMax: Float = 0
    var instrumentRange: UInt16 = 0
    var axisMode: AxisMode = AxisMode.Unknown
    var flags: [UInt8] = []
    var dcCount: UInt16  = 0
    var refCount: UInt16 = 0
    var sampleCount: UInt16 = 0
    var instrumentType: InstrumentType = InstrumentType.UnknownInstrument
    var bulbId: UInt32 = 0
    var swir1Gain: UInt16 = 0
    var swir2Gain: UInt16 = 0
    var swir1Offset: UInt16 = 0
    var swir2Offset: UInt16 = 0
    var splice1WaveLength: Float = 0
    var splice2WaveLength: Float = 0
    
    // MARK: Spectral Data
    var spectrum: [Double] = [] // size of channels
    
}

class SpectralFileV8 : SpectralFileBase {
    

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
