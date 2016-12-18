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
    var darkCurrentCorrection: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func testAquire(_ sender: Any) {
        let spectrum = aquire(samples: 10)
        
        if (darkCurrentSpectrum != nil) {
            spectrum.subtractDarkCurrent(darkCurrent: darkCurrentSpectrum!, darkCurrentCorrection: Float(darkCurrentCorrection), startingWaveLength: startingWaveLength, endingWaveLength: endingWaveLength)
        }
        
        lineChart.setAxisValues(min: 0, max: 65000)
        updateChart(data: spectrum.getChartData())
    }
    
    @IBAction func darkCurrent(_ sender: Any) {
        
        let startingWavelength = initialize(valueName: "VStartingWavelength")
        let endingWavelength = initialize(valueName: "VEndingWavelength")
        let darkCurrentCorrection = initialize(valueName: "VDarkCurrentCorrection")
        
        closeShutter()
        darkCurrentSpectrum = aquire(samples: 25)
        openShutter()
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
        darkCurrent(self)
        whiteReferenceSpectrum = aquire(samples: 25)
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
