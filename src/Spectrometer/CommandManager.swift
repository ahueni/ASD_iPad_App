//
//  CommandManager.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 23.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class CommandManager {
    
    // handle command manager as a singelton
    static let sharedInstance = CommandManager()
    private init() { }
    
    let tcpManager: TcpManager = TcpManager.sharedInstance
    
    // used to queue requests to spectrometer. It is essential that only one request at a time is processing
    let serialQueue = DispatchQueue(label: "spectrometerQueue")
    
    func aquire(samples: Int32) -> FullRangeInterpolatedSpectrum {
        
        var spectrum: FullRangeInterpolatedSpectrum!
        
        serialQueue.sync {
            spectrum = internalAquire(samples: samples)
        }
        
        return spectrum
    }
    
    func aquireCollect(samples: Int32) -> FullRangeInterpolatedSpectrum {
        
        var spectrums = [FullRangeInterpolatedSpectrum]()
        for _ in 1...samples{
            serialQueue.sync {
                spectrums.append(internalAquire(samples: 1))
            }
        }
        
        var resultSpectrumBuffer = [Float](repeating: 0, count: spectrums.first!.spectrumBuffer.count)
        for i in 0...spectrums.first!.spectrumBuffer.count - 1{
            for spectrum in spectrums{
                resultSpectrumBuffer[i] += spectrum.spectrumBuffer[i]
            }
            resultSpectrumBuffer[i] = resultSpectrumBuffer[i] / Float(samples)
        }
        let spectrum = spectrums.first!
        spectrum.spectrumBuffer = resultSpectrumBuffer
        return spectrum
        
    }
    
    func darkCurrent(sampleCount: Int32) -> Void {
        
        serialQueue.sync {
            // optimize is not needed here
            //internOptimize()
            closeShutter()
            InstrumentSettingsCache.sharedInstance.darkCurrent = internalAquire(samples: sampleCount)
            openShutter()
        }
        
    }
    
    func initialize() -> Void {
        serialQueue.sync {
            // initialize values from spectrometer
            let startingWavelength = initialize(valueName: "StartingWavelength")
            let endingWavelength = initialize(valueName: "EndingWavelength")
            let vinirStartingWavelength = initialize(valueName: "VStartingWavelength")
            let vinirEndingWavelength = initialize(valueName: "VEndingWavelength")
            let s1StartingWavelength = initialize(valueName: "S1StartingWavelength")
            let s1EndingWavelength = initialize(valueName: "S1EndingWavelength")
            let s2StartingWavelength = initialize(valueName: "S2StartingWavelength")
            let s2EndingWavelength = initialize(valueName: "S2EndingWavelength")
            
            let vinirDarkCurrentCorrection = initialize(valueName: "VDarkCurrentCorrection")
            
            InstrumentSettingsCache.sharedInstance.startingWaveLength = Int(startingWavelength.value)
            InstrumentSettingsCache.sharedInstance.endingWaveLength = Int(endingWavelength.value)
            InstrumentSettingsCache.sharedInstance.vinirStartingWavelength = Int(vinirStartingWavelength.value)
            InstrumentSettingsCache.sharedInstance.vinirEndingWavelength = Int(vinirEndingWavelength.value)
            InstrumentSettingsCache.sharedInstance.s1StartingWavelength = Int(s1StartingWavelength.value)
            InstrumentSettingsCache.sharedInstance.s1EndingWavelength = Int(s1EndingWavelength.value)
            InstrumentSettingsCache.sharedInstance.s2StartingWavelength = Int(s2StartingWavelength.value)
            InstrumentSettingsCache.sharedInstance.s2EndingWavelength = Int(s2EndingWavelength.value)
            
            InstrumentSettingsCache.sharedInstance.vinirDarkCurrentCorrection = vinirDarkCurrentCorrection.value
        }
    }
    
    func restore() -> Void {
        
        serialQueue.sync {
            
            let restoreCommand = Command(commandParam: CommandEnum.Restore, params: "1")
            _ = tcpManager.sendCommand(command: restoreCommand)
            
        }
        
    }
    
    func optimize() -> Void {
        serialQueue.sync {
            internOptimize()
        }
    }
    
    func setVinirIntegrationTime(index: Int) -> Void {
        
        serialQueue.sync {
            let command:Command = Command(commandParam: CommandEnum.InstrumentControl, params: "2,0," + index.description)
            _ = tcpManager.sendCommand(command: command)
        }
    }
    
    func addCancelCallback(callBack: () -> Void) {
        serialQueue.sync {
            callBack()
        }
    }
    
    internal func internalAquire(samples: Int32) -> FullRangeInterpolatedSpectrum {
        let command:Command = Command(commandParam: CommandEnum.Aquire, params: "1," + samples.description)
        let data = tcpManager.sendCommand(command: command)
        let spectrumParser = FullRangeInterpolatedSpectrumParser(data: data)
        return spectrumParser.parse()
    }
    
    internal func closeShutter() -> Void {
        let closeShutterIC:Command = Command(commandParam: CommandEnum.InstrumentControl, params: "2,3,1")
        _ = tcpManager.sendCommand(command: closeShutterIC)
    }
    
    internal func openShutter() -> Void {
        let openShutterIC:Command = Command(commandParam: CommandEnum.InstrumentControl, params: "2,3,0")
        _ = tcpManager.sendCommand(command: openShutterIC)
    }
    
    internal func internOptimize() -> Void {
        let command:Command = Command(commandParam: CommandEnum.Optimize, params: "7")
        _ = tcpManager.sendCommand(command: command)
    }

    
    internal func initialize(valueName: String) -> Parameter {
        let command:Command = Command(commandParam: CommandEnum.Initialize, params: "0,"+valueName)
        let data = tcpManager.sendCommand(command: command)
        let parameterParser = ParameterParser(data: data)
        return parameterParser.parse()
    }
}
