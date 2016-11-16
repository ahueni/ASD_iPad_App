//
//  CommandEnum.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

enum CommandEnum: String {
    case Aquire = "C"
    case Abort = "ABORT"
    case InstrumentControl = "IC"
    case Initialize = "INIT"
    case Optimize = "OPT"
    case Restore = "RESTORE"
    case Save = "SAVE"
    case Version = "V"
}

class Command {
    
    let command: CommandEnum
    let parameters: String
    let size: Int
    
    init(commandParam: CommandEnum, params: String) {
        
        switch commandParam {
        case .Aquire:
            size = FullRangeInterpolatedSpectrum.SIZE
        case .Abort:
            size = Parameter.SIZE
        case .InstrumentControl:
            size = InstrumentControl.SIZE
        case .Initialize:
            size = Parameter.SIZE
        case .Optimize:
            size = Optimize.SIZE
        case .Restore:
            size = Init.SIZE
        case .Save:
            size = Init.SIZE
        case .Version:
            size = Version.SIZE
        }
        
        command = commandParam
        parameters = params
    }
    
    func getCommandString() -> String {
        if parameters == "" {
            return command.rawValue
        }
        return command.rawValue+","+parameters
    }
    
    
}
