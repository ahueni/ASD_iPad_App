//
//  SpectralFile.swift
//  Spectrometer
//
//  Created by raphi on 02.12.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

class SpectralFileBase {
    
    /*
    // MARK: Spectral File Header
    var fileVersion: String
    var comments: String
    var savedAt: Date = Date()
    var dayLightSavingFlag: Int
    var programVersion: UInt8
    var fileFormatVersion: UInt8
    var dcCorrected: Bool
    var dcTime: UInt32
    var dataType: DataType
    var refTime: UInt32
    var startingWaveLength: Float
    var waveLengthStep: Float
    var oldDcCount: UInt8
    var oldRefCount: UInt8
    var oldSampleCount: UInt8
    var application: UInt8
    var channels: UInt16
    var appData: AppData
    var gpsData: GpsData
    var integrationTime: UInt32
    var fo: Int8
    var darkCurrentCorrection: Int8
    var calibrationSeries: UInt16
    var instrumentNumber: UInt16
    var yMin: Float
    var yMax: Float
    var xMin: Float
    var xMax: Float
    var instrumentRange: UInt16
    var axisMode: AxisMode
    var flags: [UInt8]
    var dcCount: UInt8
    var refCount: UInt8
    var sampleCount: UInt8
    var instrumentType: InstrumentType
    var bulbId: UInt32
    var swir1Gain: UInt16
    var swir2Gain: UInt16
    var swir1Offset: UInt16
    var swir2Offset: UInt16
    var splice1WaveLength: Float
    var splice2WaveLength: Float
    
    // MARK: Spectral Data
    var spectrum: [Double] // size of channels
    
    // MARK: Reference File Header
    var ReferenceFlag: Bool // why 2bytes?
    var ReferenceTime: Date // 8 Bytes
    var SpectrumTime: Date // 8 Bytes
    var SpectrumDescription: String //size ?!?
    
    // MARK: Reference Spectral Data
    var reference: [Double]
    
    // MARK: Classifier Data
    var yCode: ClassifierType
    var yModelType: UInt8
    var sTitle: String
    var sSubTitle: String
    var sProductName: String
    var sVendor: String
    var sLotNumber: String
    var sSample: String
    var sModelName: String
    var sOperator: String
    var sDateTime: String
    var sInstrument: String
    var sSerialNumber: String
    var sDisplayMode: String
    var sComments: String
    var sUnits: String
    var sFilename: String
    var sUserName: String
    var sReserved1: String
    var sReserved2: String
    var sReserved3: String
    var sReserved4: String
    var constituentCount: UInt16
    var actConstituent: ConstituentType
    
    // MARK: Dependent Variables
    var SaveDependentVariables: Bool
    var DependentVariableCount: UInt16
    var DependentVariableLabels: String
    var DependentVariables: Float
    
    // MARK: Calibration Header
    var calibrationCount: UInt8
    var calibrationBuffer: CalibrationBuffer
    
    // MARK: Base Calibration Data
    var baseCalibrationData: [Double]
    
    // MARK: Lamp Calibration Data
    var lampCalibrationData: [Double]
    
    // MARK: Fiber Optic Data
    var fiberOpticData: [Double]
    */
    
    init() {
        
    }
    
}

class SpectralFileV7 : SpectralFileBase {
    
    /*
    // MARK: Spectral File Header V7
    var WhenInMs: String // 12 bytes
    var reservedBytes: UInt8 = 20
    */
    
    override init() {
        
    }
    
    
}


class SpectralFileV8 : SpectralFileBase {
    
    /*
    // MARK: Spectral File Header V8
    var smartDetectorType: Float // 27bytes ?!?
    var reservedBytes: UInt8 = 5
    
    // MARK: Audit Log
    var auditCount: UInt32
    var auditEvents: [String]
    
    // MARK: Signature
    */
    
    override init() {
        
    }
    
}
