//
//  ReturnTypes.swift
//  SocketTesting
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

struct VnirHeader {
    var IT: Int
    var scans: Int
    var maxChannel: Int
    var minChannel: Int
    var saturation: Int
    var shutter: Int
    var drift: Int
    var darkSubtracted: Int
    var reserved: [Int]
}

struct SwirHeader {
    var tecStatus: Int
    var tecCurrent: Int
    var maxChannel: Int
    var minchannel: Int
    var saturation: Int
    var AScans: Int
    var BScans: Int
    var darkCurrent: Int
    var gain: Int
    var offset: Int
    var scansize1: Int
    var scansize2: Int
    var darkSubtracted: Int
    var reserved: [Int]
}

struct SpectrumHeader {
    var header: SpectrumHeaderStatus
    var error: SpectrumHeaderError
    var sampleCount: Int
    var trigger: Int
    var voltage: Int
    var current: Int
    var temperature: Int
    var motorCurrent: Int
    var instrumentHours: Int
    var instrumentMinutes: Int
    var instrumentType: Int
    var AB: Int
    var reserved: [Int]
    var vHeader: VnirHeader
    var s1Header: SwirHeader
    var s2Header: SwirHeader
}

enum SpectrumHeaderStatus: Int {
    case NoError = 0
    case CollectError = 200
    case CollectNotLoaded = 300
    case ResetError = 600
    case InterpolateError = 700
}

enum SpectrumHeaderError: Int {
    case NoError = 0
    case NotReady = -1
    case NoIndexMarks = -2
    case TooManyZeros = -3
    case ScanSizeError = -4
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


// C -
struct FrInterpSpec {
    let size:Int = 11904
    var spectrumHeader: SpectrumHeader
    var specBuffer: [Float]
}

// ABORT - INIT
struct Param {
    let size:Int = 50
    var header: Int
    var errbyte: Int
    var name: [String]
    var value: Double
    var count: Int
}

// ERASE - RESTORE - SAVE
struct Init {
    let size:Int = 50
    var header: Int
    var errbyte: Int
    var name: [[String]]
    var values: [Double]
    var count: Int
}

// IC
struct InstrumentControl
{
    let size:Int = 20
    var header: Int
    var errbyte: Int
    var detector: Int
    var cmdType: Int
    var value: Int
}

// OPT
struct Optimize {
    let size:Int = 28
    var header: Int
    var errbyte: Int
    var itime: Int
    var gain: [Int]
    var offset: [Int]
    
}

// V
struct Version {
    let size:Int = 50
    var header: Int
    var errbyte: Int
    var version: String
    var versionNumber: Double
    var type: Int
}
