//
//  SpectralFileEnums.swift
//  Spectrometer
//
//  Created by raphi on 02.12.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

enum InstrumentType: UInt8 {
    
    case UnknownInstrument = 0
    case PsiiInstrument = 1
    case LsVnirInstrument = 2
    case FsVnirInstrument = 3
    case FsFrInstrument = 4
    case FsNirInstrument = 5
    case ChemInstrument = 6
    case FsFrUnattendedInstrument = 7
    
}

enum DataType: UInt8 {
    
    case RawType = 0
    case RefType = 1
    case RadType = 2
    case NounitsType = 3
    case IrradType = 4
    case QiType = 5
    case TransType = 6
    case UnknownType = 7
    case AbsType = 8
    
}

enum DataFormat: UInt8 {
    
    case FloatFormat = 0
    case IntegerFormat = 1
    case DoubleFormat = 2
    case UnknownFormat = 3
    
}

enum AxisMode: UInt8 {
    
    case Unknown = 0
    
}

enum ClassifierType: UInt8 {
    
    case Sam = 0
    case Galactic = 1
    case Camopredict = 2
    case Camoclassify = 3
    case Pcaz = 4
    case Infometrix = 5
    
}
