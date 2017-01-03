//
//  AquireViewController.swift
//  Spectrometer
//
//  Created by raphi on 19.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit
import Charts

class AquireViewController: UIViewController {
    
    // buttons
    @IBOutlet var aquireButton: UIButton!
    
    // chart
    @IBOutlet var lineChart: SpectrumLineChartView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let tcpManager: TcpManager = (UIApplication.shared.delegate as! AppDelegate).tcpManager!
    
    var darkCurrentSpectrum: FullRangeInterpolatedSpectrum? = nil
    var whiteReferenceSpectrum: FullRangeInterpolatedSpectrum? = nil
    
    var startingWaveLength: Int = 0
    var endingWaveLength: Int = 0
    var vinirEndingWavelength: Int = 0
    var vinirDarkCurrentCorrection: Float = 0
    
    var drift: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func testAquire(_ sender: Any) {
        let spectrum = aquire(samples: 10)
        
        if (darkCurrentSpectrum != nil) {
            spectrum.subtractDarkCurrent(darkCurrent: darkCurrentSpectrum!, startingWaveLength: startingWaveLength, endingWaveLength: vinirEndingWavelength, drift: drift)
        }
        
        lineChart.setAxisValues(min: 0, max: 65000)
        updateChart(data: spectrum.getChartData())
    }
    
    @IBAction func darkCurrent(_ sender: Any) {
        
        startingWaveLength = Int(initialize(valueName: "StartingWavelength").value)
        //endingWaveLength = initialize(valueName: "EndingWavelength").value
        //vinirStartingWavelength = initialize(valueName: "VStartingWavelength").value
        vinirEndingWavelength = Int(initialize(valueName: "VEndingWavelength").value)
        vinirDarkCurrentCorrection = Float(initialize(valueName: "VDarkCurrentCorrection").value)
        
        optimize()

        closeShutter()
        darkCurrentSpectrum = aquire(samples: 10)
        let darkDrift = darkCurrentSpectrum?.spectrumHeader.vHeader.drift
        openShutter()
        
        let aquireData = aquire(samples: 10)
        let currentDrift = aquireData.spectrumHeader.vHeader.drift
        
        drift = vinirDarkCurrentCorrection + Float((currentDrift - darkDrift!))
    }
    
    @IBAction func openShutter(_ sender: Any) {
        openShutter()
    }
    
    @IBAction func closeShutter(_ sender: Any) {
        closeShutter()
    }
    
    @IBAction func radiance(_ sender: Any) {
        
    }
    
    @IBAction func whiteReference(_ sender: UIButton) {
        
        startingWaveLength = Int(initialize(valueName: "StartingWavelength").value)
        endingWaveLength = Int(initialize(valueName: "EndingWavelength").value)
        
        let refrenceSpectrum = aquire(samples: 10)
        
        //darkCurrent(self)
        let aquireData = aquire(samples: 10)
        
        // Compute Reflectance
        for i in 0 ... ((endingWaveLength + 1) - startingWaveLength){
            aquireData.spectrumBuffer[i] = aquireData.spectrumBuffer[i] / refrenceSpectrum.spectrumBuffer[i]
        }
    }
    
    
    @IBAction func optimizeClicked(_ sender: Any) {
        optimize()
    }
    
    func optimize() -> Void {
        let command:Command = Command(commandParam: CommandEnum.Optimize, params: "7")
        let data = tcpManager.sendCommand(command: command)
    }
    
    
    
    func aquire(samples: Int) -> FullRangeInterpolatedSpectrum {
        let command:Command = Command(commandParam: CommandEnum.Aquire, params: "1," + samples.description)
        let data = tcpManager.sendCommand(command: command)
        let spectrumParser = FullRangeInterpolatedSpectrumParser(data: data)
        return spectrumParser.parse()
    }
    
    func initialize(valueName: String) -> Parameter {
        let command:Command = Command(commandParam: CommandEnum.Initialize, params: "0,"+valueName)
        let data = tcpManager.sendCommand(command: command)
        let parameterParser = ParameterParser(data: data)
        return parameterParser.parse()
    }
    
    func showData(data: [UInt8])-> Void{
        let parameterParser = ParameterParser(data: data)
        return parameterParser.parse()
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
    
    func updateChart(data: LineChartData) -> Void {
        lineChart.data = data
    }
    
    
}
