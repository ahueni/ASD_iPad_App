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
    case Swir2InterpolateError = -22
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
}

enum InstrumentControlValues: Int {
    case It = 0
    case Gain = 1
    case Offset = 2
    case Shutter = 3
    case Trigger = 4
}

enum Saturation: Int {
    case NoSaturation = 0
    case Saturation = 1
}

enum ShutterStatus: Int {
    case Open = 0
    case Closed = 1
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
