//
//  SpectrumEnums.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

enum HeaderValues: Int {
    case NoError = 100
    case CollectError = 200
    case CollectNotLoaded = 300
    case InitError = 400
    case FlashError = 500
    case ResetError = 600
    case InterpolateError = 700
    case OptimizeError = 800
    case InstrumentControlError = 900
    case UnknownError = 999
    
    init(fromRawValue: Int){
        self = HeaderValues(rawValue: fromRawValue) ?? .UnknownError
    }
    
}

enum ErrorCodes: Int {
    case NoError = 0
    case NotReady = -1
    case NoIndexMarks = -2
    case TooManyZeros = -3
    case ScanSizeError = -4
    // -5 unused
    case CommandError = -6
    case IniFull = -7
    case MissingParameter = -8
    // -9 unused
    case VnirTimeout = -10
    case SwirTimeout = -11
    case VnirNotReady = -12
    case Swir1NotReady = -13
    case Swir2NotReady = -14
    case AbortError = -18
    case VnirInterpolateError = -20
    case Swir1InterpolateError = -21
    case UnknownError = 99
    
    init(fromRawValue: Int){
        self = ErrorCodes(rawValue: fromRawValue) ?? .UnknownError
    }
    
}

enum InstrumentTypes: Int {
    case VinirOnly = 1
    case DualVinir = 2
    case Swir1Only = 4
    case VinirSwir1 = 5
    case Swir2Only = 8
    case VinirSwir2 = 9
    case Swir1Swir2 = 12
    case VinirSwir1Swir2 = 13
    case UnknownInstrument = 99
    
    init(fromRawValue: Int){
        self = InstrumentTypes(rawValue: fromRawValue) ?? .UnknownInstrument
    }
    
}

enum InstrumentControlValues: Int {
    case It = 0
    case Gain = 1
    case Offset = 2
    case Shutter = 3
    case Trigger = 4
    case UnknownError = 99
    
    init(fromRawValue: Int){
        self = InstrumentControlValues(rawValue: fromRawValue) ?? .UnknownError
    }
}

enum Saturation: Int {
    case NoSaturation = 0
    case Saturated = 1
    
    init(fromRawValue: Int){
        self = Saturation(rawValue: fromRawValue) ?? .Saturated
    }
    
}

enum ShutterStatus: Int {
    case Open = 0
    case Closed = 1
    case Error = 99
    
    init(fromRawValue: Int){
        
        if (fromRawValue > 1) { print("ShutterStatus: " + fromRawValue.description) }        
        self = ShutterStatus(rawValue: fromRawValue) ?? .Error
    }
    
}

enum DarkSubtracted: Int {
    case No = 0
    case Yes = 1
}

enum TecStatus: Int {
    case NoAlarm = 0
    case Alarm1 = 1
    case Alarm2 = 2
}

enum Trigger: Int {
    case Off = 0
    case On = 1
}

struct IntegrationTimeMapper {
    
    static func mapIndex(index : Int) -> (Int, Float){
        
        switch(index) {
        case -1:
            return (index, 8.5)
        case 0:
            return (index, 17)
        case 1:
            return (index, 34)
        case 2:
            return (index, 68)
        case 3:
            return (index, 136)
        case 4:
            return (index, 272)
        case 5:
            return (index, 544)
        case 6:
            return (index, 1090)
        case 7:
            return (index, 2180)
        case 8:
            return (index, 4350)
        case 9:
            return (index, 8700)
        case 10:
            return (index, 17410)
        case 11:
            return (index, 34820)
        case 12:
            return (index, 69600)
        case 13:
            return (index, 139200)
        case 14:
            return (index, 278400)
        case 15:
            return (index, 556800)
        default:
            return (-1, 8.5)
        }
        
    }
    
}
