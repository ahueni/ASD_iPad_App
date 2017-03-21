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
    
    init(fromRawValue: Int) throws {
        if let value = InstrumentTypes(rawValue: fromRawValue) {
            self = value
        } else {
            throw SpectrometerError(message: "Could not parse instrument type of spectrum.", kind: .parsingError)
        }
    }
}

enum InstrumentControlValues: Int {
    case It = 0
    case Gain = 1
    case Offset = 2
    case Shutter = 3
    case Trigger = 4
    
    init(fromRawValue: Int) throws {
        if let value = InstrumentControlValues(rawValue: fromRawValue) {
            self = value
        } else {
            throw SpectrometerError(message: "Could not parse instrument control of spectrum.", kind: .parsingError)
        }
    }
}

enum Saturation: Int {
    case NoSaturation = 0
    case Saturated = 1
    
    init(fromRawValue: Int) throws {
        if let value = Saturation(rawValue: fromRawValue) {
            self = value
        } else {
            throw SpectrometerError(message: "Could not parse saturation of spectrum.", kind: .parsingError)
        }
    }
}

enum ShutterStatus: Int {
    case Open = 0
    case Closed = 1
    
    init(fromRawValue: Int) throws {
        if let value = ShutterStatus(rawValue: fromRawValue) {
            self = value
        } else {
            throw SpectrometerError(message: "Could not parse shutter status of spectrum.", kind: .parsingError)
        }
    }
}

enum DarkSubtracted: Int {
    case No = 0
    case Yes = 1
    
    init(fromRawValue: Int) throws {
        if let value = DarkSubtracted(rawValue: fromRawValue) {
            self = value
        } else {
            throw SpectrometerError(message: "Could not parse dark subtracted of spectrum.", kind: .parsingError)
        }
    }
}

enum TecStatus: Int {
    case NoAlarm = 0
    case Alarm1 = 1
    case Alarm2 = 2
    
    init(fromRawValue: Int) throws {
        if let value = TecStatus(rawValue: fromRawValue) {
            self = value
        } else {
            throw SpectrometerError(message: "Could not parse tec status of spectrum.", kind: .parsingError)
        }
    }
}

enum Trigger: Int {
    case Off = 0
    case On = 1
    
    init(fromRawValue: Int) throws {
        if let value = Trigger(rawValue: fromRawValue) {
            self = value
        } else {
            throw SpectrometerError(message: "Could not parse trigger of spectrum.", kind: .parsingError)
        }
    }
}

struct IntegrationTime {
    
    static let integrationTimes:[(Int, Float)] =  [(-1, 8.5),(0, 17),(1, 34),(2, 68),(3, 136),(4, 272),(5, 544),(6, 1090),(7, 2180),(8, 4350),(9, 8700),(10, 17410),(11, 34820),(12, 69600),(13, 139200),(14, 278400),(15, 556800)]
    
    static func getIntegrationTime(index: Int) -> Float {
        if let first = integrationTimes.first(where: { $0.0 == index }) {
            return first.1
        }
        return 8.5
    }
    
    static func getIndex(integrationTime: Float) -> Int {
        if let first = integrationTimes.first(where: { $0.1 >= integrationTime }) {
            return first.0
        }
        return -1
    }
    
    
}

