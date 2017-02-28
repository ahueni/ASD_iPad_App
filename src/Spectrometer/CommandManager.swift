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
    
    func darkCurrent() -> Void {
        
        serialQueue.sync {
            
            // only to have first a aquire command -> rs3 dose the same result is not nescessary
            _ = internalAquire(samples: 2)
            
            // get all wavelengths to have darkcurrent calculation wavelengths
            getWaveLengthts()
            
            // optimice -> rs3 dose the same
            internOptimize()
            
            closeShutter()
            InstrumentSettingsCache.sharedInstance.darkCurrent = internalAquire(samples: 10)
            openShutter()
        }
        
    }
    
    internal func internalAquire(samples: Int32) -> FullRangeInterpolatedSpectrum {
        let command:Command = Command(commandParam: CommandEnum.Aquire, params: "1," + samples.description)
        let data = tcpManager.sendCommand(command: command)
        let spectrumParser = FullRangeInterpolatedSpectrumParser(data: data)
        return spectrumParser.parse()
    }
    
    internal func getWaveLengthts(){
        
        let startingWavelength = initialize(valueName: "StartingWavelength")
        let endingWavelength = initialize(valueName: "EndingWavelength")
        let vinirStartingWavelength = initialize(valueName: "VStartingWavelength")
        let vinirEndingWavelength = initialize(valueName: "VEndingWavelength")
        
        let vinirDarkCurrentCorrection = initialize(valueName: "VDarkCurrentCorrection")
        
        
        InstrumentSettingsCache.sharedInstance.startingWaveLength = Int(startingWavelength.value)
        InstrumentSettingsCache.sharedInstance.endingWaveLength = Int(endingWavelength.value)
        InstrumentSettingsCache.sharedInstance.vinirStartingWavelength = Int(vinirStartingWavelength.value)
        InstrumentSettingsCache.sharedInstance.vinirEndingWavelength = Int(vinirEndingWavelength.value)
        
        InstrumentSettingsCache.sharedInstance.vinirDarkCurrentCorrection = vinirDarkCurrentCorrection.value
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
    
    func optimize() -> Void {
        serialQueue.sync {
            internOptimize()
        }
    }
    
    internal func initialize(valueName: String) -> Parameter {
        let command:Command = Command(commandParam: CommandEnum.Initialize, params: "0,"+valueName)
        let data = tcpManager.sendCommand(command: command)
        let parameterParser = ParameterParser(data: data)
        return parameterParser.parse()
    }
}
