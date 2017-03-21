//
//  CommandManager.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 23.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class CommandManager {
    
    // handle command manager as a singelton
    static let sharedInstance = CommandManager()
    private init() { }
    
    let tcpManager: TcpManager = TcpManager.sharedInstance
    
    // used to queue requests to spectrometer. It is essential that only one request at a time is processing
    let serialQueue = DispatchQueue(label: "spectrometerQueue")
    
    func aquire(samples: Int32, successCallBack:(_ spectrum: FullRangeInterpolatedSpectrum) -> Void, errorCallBack:(_ error: Error) -> Void) -> Void {
        
        var spectrum: FullRangeInterpolatedSpectrum!
        do {
            try serialQueue.sync {
                spectrum = try internalAquire(samples: samples)
            }
        } catch let error {
            errorCallBack(error)
            return
        }
        successCallBack(spectrum)
    }
    
    func darkCurrent(sampleCount: Int32, successCallBack:(() -> Void)? = nil, errorCallBack:(_ error: Error) -> Void) -> Void {
        
        do {
            try serialQueue.sync {
                try closeShutter()
                InstrumentStore.sharedInstance.darkCurrent = try internalAquire(samples: sampleCount)
                try openShutter()
            }
        } catch let error {
            errorCallBack(error)
            return
        }
        
        // call success callback
        if let success = successCallBack {
            success()
        }

    }
    
    func initialize(successCallBack:(() -> Void)?, errorCallBack:(_ error: Error) -> Void) -> Void {
        
        do {
            try serialQueue.sync {
                // initialize values from spectrometer
                let serialNumber = try initialize(valueName: "SerialNumber")
                
                let startingWavelength = try initialize(valueName: "StartingWavelength")
                let endingWavelength = try initialize(valueName: "EndingWavelength")
                let vinirStartingWavelength = try initialize(valueName: "VStartingWavelength")
                let vinirEndingWavelength = try initialize(valueName: "VEndingWavelength")
                let s1StartingWavelength = try initialize(valueName: "S1StartingWavelength")
                let s1EndingWavelength = try initialize(valueName: "S1EndingWavelength")
                let s2StartingWavelength = try initialize(valueName: "S2StartingWavelength")
                let s2EndingWavelength = try initialize(valueName: "S2EndingWavelength")
                
                let vinirDarkCurrentCorrection = try initialize(valueName: "VDarkCurrentCorrection")
                
                InstrumentStore.sharedInstance.serialNumber = Int(serialNumber.value)
                
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
        } catch let error {
            errorCallBack(error)
            return
        }
        
        // call sucess callback at the end
        if let success = successCallBack {
            success()
        }
    }
    
    func restore(successCallBack: (() -> Void)? = nil, errorCallBack:(_ error: Error) -> Void) -> Void {
        let restoreCommand = Command(commandParam: CommandEnum.Restore, params: "1")
        // serial queue with restore command
        do {
            try serialQueue.sync {
                _ = try tcpManager.sendCommand(command: restoreCommand)
            }
        } catch let error {
            errorCallBack(error)
            return
        }
        
        // call sucess callback at the end
        if let success = successCallBack {
            success()
        }
    }
    
    func optimize(successCallBack: (() -> Void)? = nil, errorCallBack:(_ error: Error) -> Void) -> Void {
        do {
            try serialQueue.sync {
                try internOptimize()
            }
        } catch let error {
            errorCallBack(error)
            return
        }
        
        // call sucess callback at the end
        if let success = successCallBack {
            success()
        }
    }
    
    func setInstrumentControl(successCallBack: (() -> Void)? = nil, instrumentControlValues: ICValues, errorCallBack:(_ error: Error) -> Void) {
        
        do {
            try serialQueue.sync {
                // set integration Time
                try internalInstrumentControl(params: "2,0," + instrumentControlValues.integrationTime.description)
                //set swir1Gain
                try internalInstrumentControl(params: "0,1," + instrumentControlValues.swir1Gain.description)
                //set swir1Offset
                try internalInstrumentControl(params: "0,2," + instrumentControlValues.swir1Offset.description)
                //set swir2Gain
                try internalInstrumentControl(params: "1,1," + instrumentControlValues.swir2Gain.description)
                //set swir2Offset
                try internalInstrumentControl(params: "1,2," + instrumentControlValues.swir2Offset.description)
            }
        } catch let error {
            errorCallBack(error)
            return
        }
        
        // call sucess callback at the end
        if let success = successCallBack {
            success()
        }
    }
    
    func abort(successCallBack: (() -> Void)? = nil, errorCallBack:(_ error: Error) -> Void) -> Void {
        // put this command not in a serial queue that its possible to abort a very long aquire command!
        let abortCommand = Command(commandParam: .Abort, params: "")
        
        do {
            _ = try tcpManager.sendCommand(command: abortCommand)
        } catch let error {
            errorCallBack(error)
            return
        }
        
        // call sucess callback
        if let success = successCallBack {
            success()
        }
    }
    
    func addCancelCallback(callBack: () -> Void) {
        serialQueue.sync {
            callBack()
        }
    }
    
    private func internalAquire(samples: Int32) throws -> FullRangeInterpolatedSpectrum {
        let command:Command = Command(commandParam: CommandEnum.Aquire, params: "1," + samples.description)
        let data = try tcpManager.sendCommand(command: command)
        let spectrumParser = FullRangeInterpolatedSpectrumParser(data: data)
        return try spectrumParser.parse()
    }
    
    private func initialize(valueName: String) throws -> Parameter {
        let command:Command = Command(commandParam: CommandEnum.Initialize, params: "0,"+valueName)
        let data = try tcpManager.sendCommand(command: command)
        let parameterParser = ParameterParser(data: data)
        return try parameterParser.parse()
    }
    
    private func internOptimize() throws -> Void {
        let command:Command = Command(commandParam: CommandEnum.Optimize, params: "7")
        _ = try tcpManager.sendCommand(command: command)
    }
    
    private func internalInstrumentControl(params : String) throws -> Void {
        let icCommand : Command = Command(commandParam: CommandEnum.InstrumentControl, params: params)
        _ = try tcpManager.sendCommand(command: icCommand)
    }
    
    private func closeShutter() throws -> Void {
        try internalInstrumentControl(params: "2,3,1")
    }
    
    private func openShutter() throws -> Void {
        try internalInstrumentControl(params: "2,3,0")
    }
}
