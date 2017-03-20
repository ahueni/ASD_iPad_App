//
//  IndicoFileBase.swift
//  Spectrometer
//
//  Created by raphi on 06.03.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class IndicoFileBase {
    
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
    var integrationTime: Float = 0
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
