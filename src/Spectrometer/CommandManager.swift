//
//  CommandManager.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 23.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class CommandManager{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let tcpManager: TcpManager = (UIApplication.shared.delegate as! AppDelegate).tcpManager!
    // used to queue requests to spectrometer. It is essential that only one request at a time is processing
    let serialQueue = DispatchQueue(label: "spectrometerQueue")
    
    static let sharedInstance = CommandManager()
    
    // prevent other instances of this class
    private init() {
    }
    
    func getWaveLengthts(){
        InstrumentSettingsCache.sharedInstance.startingWaveLength = Int(initialize(valueName: "StartingWavelength").value)
        InstrumentSettingsCache.sharedInstance.endingWaveLength = Int(initialize(valueName: "EndingWavelength").value)
        InstrumentSettingsCache.sharedInstance.vinirStartingWavelength = Int(initialize(valueName: "VStartingWavelength").value)
        InstrumentSettingsCache.sharedInstance.vinirEndingWavelength = Int(initialize(valueName: "VEndingWavelength").value)
        InstrumentSettingsCache.sharedInstance.vinirDarkCurrentCorrection = initialize(valueName: "VDarkCurrentCorrection").value
    }
    
    func aquire(samples: Int32) -> FullRangeInterpolatedSpectrum {
        var spectrumParser :FullRangeInterpolatedSpectrumParser? = nil
        print("queue starts")
        serialQueue.sync {
            print("queue sync")
            let command:Command = Command(commandParam: CommandEnum.Aquire, params: "1," + samples.description)
            let data = tcpManager.sendCommand(command: command)
            spectrumParser = FullRangeInterpolatedSpectrumParser(data: data)
            print("queue finished")
        }
        print("return aquire")
        return spectrumParser!.parse()
    }
    
    func darkCurrent() -> FullRangeInterpolatedSpectrum{
        CommandManager.sharedInstance.getWaveLengthts()
        
        CommandManager.sharedInstance.optimize()
        
        closeShutter()
        let darkCurrentSpectrum = CommandManager.sharedInstance.aquire(samples: 10)
        InstrumentSettingsCache.sharedInstance.darkDrift = darkCurrentSpectrum.spectrumHeader.vinirHeader.drift
        openShutter()
        return darkCurrentSpectrum
    }
    
    
    
    func closeShutter() -> Void {
        let closeShutterIC:Command = Command(commandParam: CommandEnum.InstrumentControl, params: "2,3,1")
        
        //_ = tcpManager.sendCommand(command: closeShutterA)
        _ = tcpManager.sendCommand(command: closeShutterIC)
    }
    
    func openShutter() -> Void {
        let openShutterIC:Command = Command(commandParam: CommandEnum.InstrumentControl, params: "2,3,0")
        
        //_ = tcpManager.sendCommand(command: openShutterA)
        _ = tcpManager.sendCommand(command: openShutterIC)
    }
    
    func optimize() -> Void {
        serialQueue.sync {
            let command:Command = Command(commandParam: CommandEnum.Optimize, params: "7")
            tcpManager.sendCommand(command: command)
        }
    }
    
    func initialize(valueName: String) -> Parameter {
        var parameterParser :ParameterParser? = nil
        print("queue starts")
        serialQueue.sync {
            let command:Command = Command(commandParam: CommandEnum.Initialize, params: "0,"+valueName)
            let data = tcpManager.sendCommand(command: command)
            parameterParser = ParameterParser(data: data)
            print("queue finished")
        }
        print("return initialize")
        return parameterParser!.parse()
    }
}
