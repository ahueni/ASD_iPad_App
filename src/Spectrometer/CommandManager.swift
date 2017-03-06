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
            InstrumentStore.sharedInstance.darkCurrent = internalAquire(samples: sampleCount)
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
            
            InstrumentStore.sharedInstance.startingWaveLength = Int(startingWavelength.value)
            InstrumentStore.sharedInstance.endingWaveLength = Int(endingWavelength.value)
            InstrumentStore.sharedInstance.vinirStartingWavelength = Int(vinirStartingWavelength.value)
            InstrumentStore.sharedInstance.vinirEndingWavelength = Int(vinirEndingWavelength.value)
            InstrumentStore.sharedInstance.s1StartingWavelength = Int(s1StartingWavelength.value)
            InstrumentStore.sharedInstance.s1EndingWavelength = Int(s1EndingWavelength.value)
            InstrumentStore.sharedInstance.s2StartingWavelength = Int(s2StartingWavelength.value)
            InstrumentStore.sharedInstance.s2EndingWavelength = Int(s2EndingWavelength.value)
            
            InstrumentStore.sharedInstance.vinirDarkCurrentCorrection = vinirDarkCurrentCorrection.value
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
    
    func setInstrumentControl(instrumentControlValues : ICValues){
        serialQueue.sync {
            // set integration Time
            internalInstrumentControl(params: "2," + instrumentControlValues.integrationTime.description)
            //set swir1Gain
            internalInstrumentControl(params: "0,1," + instrumentControlValues.swir1Gain.description)
            //set swir1Offset
            internalInstrumentControl(params: "0,2," + instrumentControlValues.swir1Offset.description)
            //set swir2Gain
            internalInstrumentControl(params: "1,1," + instrumentControlValues.swir2Gain.description)
            //set swir2Offset
            internalInstrumentControl(params: "1,2," + instrumentControlValues.swir2Offset.description)
        }
    }
    
    internal func internalInstrumentControl(params : String)
    {
        let icCommand : Command = Command(commandParam: CommandEnum.InstrumentControl, params: params)
        _ = tcpManager.sendCommand(command: icCommand)
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
        internalInstrumentControl(params: "2,3,1")
    }
    
    internal func openShutter() -> Void {
        internalInstrumentControl(params: "2,3,0")
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
