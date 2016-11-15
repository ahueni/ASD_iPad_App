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
            size = 11904
        case .Abort:
            size = 50
        case .InstrumentControl:
            size = 20
        case .Initialize:
            size = 50
        case .Optimize:
            size = 28
        case .Restore:
            size = 50
        case .Save:
            size = 50
        case .Version:
            size = 50
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
