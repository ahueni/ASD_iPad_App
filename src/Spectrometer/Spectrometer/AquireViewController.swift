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
import FileBrowser

class AquireViewController: UIViewController {
    
    let fileBrowser = FileBrowser()
    // used to queue requests to spectrometer. It is essential that only one request at a time is processing
    let serialQueue = DispatchQueue(label: "spectrometerQueue")
    
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
    var vinirDarkCurrentCorrection: Double = 0
    var aquireLoopOn = false // Indicates if a aquireLoop is running
    
    var darkDrift: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        darkCurrent()
    }
    
    @IBAction func startAquire(_ sender: UIButton) {
        aquireLoopOn = !aquireLoopOn
        
        DispatchQueue(label: "test").async {
            
            while(self.aquireLoopOn){
                self.aquireWithDarkCorrection()
            }
        }
    }
    
    func aquireWithDarkCorrection () {
            // Background tasks
            let spectrum = self.aquire(samples: (self.appDelegate.config?.sampleCount)!)
            let currentDrift = spectrum.spectrumHeader.vHeader.drift
            
            if (self.darkCurrentSpectrum == nil){
                return //throw SpectrometerErrors.noDarkCurrentFound
            }
            
            let drift = Float(self.vinirDarkCurrentCorrection + Double(currentDrift - self.darkDrift))
            print("Drift: " + drift.description)
            
            let darkCorrectionRange = ((self.endingWaveLength + 1) - self.startingWaveLength)
            spectrum.subtractDarkCurrent(darkCurrent: self.darkCurrentSpectrum!, darkCorrectionRange: darkCorrectionRange, drift: drift)
            
            DispatchQueue.main.async {
                //update ui
                self.lineChart.setAxisValues(min: 0, max: 65000)
                self.updateChart(data: spectrum.getChartData())
            }
    }
    
    @IBAction func darkCurrent(_ sender: Any) {
        aquireLoopOn = false
        darkCurrent()
    }
    
    @IBAction func openShutter(_ sender: Any) {
        aquireLoopOn = false
        openShutter()
    }
    
    @IBAction func closeShutter(_ sender: Any) {
        aquireLoopOn = false
        closeShutter()
    }
    
    @IBAction func radiance(_ sender: Any) {
        aquireLoopOn = false
    }
    
    @IBAction func whiteReference(_ sender: UIButton) {
        aquireLoopOn = false
        aquire(samples: 10)
    }
    
    func computeReflectance(){
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
    
    func saveSpectrum(spectrum: FullRangeInterpolatedSpectrum, whiteRefrenceSpectrum: FullRangeInterpolatedSpectrum){
        let path = ("~/Documents/test.txt" as NSString).expandingTildeInPath
        
        let fw = FileWriter(path: path)
        let fileHandle :FileHandle = fw.write(spectrum: spectrum, whiteRefrenceSpectrum: spectrum)
        
        let dataBuffer = [UInt8](FileManager().contents(atPath: path)!)
        let fileParser = SpectralFileParser(data: dataBuffer)
        
        do{
            try fileParser.parse()
            print("File succesfully parsed!")
        }
        catch{
            
            print("File not parsed!")
        }

    }
    
    func optimize() -> Void {
        serialQueue.sync {
            let command:Command = Command(commandParam: CommandEnum.Optimize, params: "7")
            tcpManager.sendCommand(command: command)
        }
    }
    
    func darkCurrent() -> Void{
        startingWaveLength = Int(initialize(valueName: "StartingWavelength").value)
        //endingWaveLength = initialize(valueName: "EndingWavelength").value
        //vinirStartingWavelength = initialize(valueName: "VStartingWavelength").value
        vinirEndingWavelength = Int(initialize(valueName: "VEndingWavelength").value)
        vinirDarkCurrentCorrection = initialize(valueName: "VDarkCurrentCorrection").value
        
        optimize()
        
        closeShutter()
        darkCurrentSpectrum = aquire(samples: 10)
        darkDrift = (darkCurrentSpectrum?.spectrumHeader.vHeader.drift)!
        openShutter()
    }
    
    func aquire(samples: Int32) -> FullRangeInterpolatedSpectrum {
        var spectrumParser :FullRangeInterpolatedSpectrumParser? = nil
        print("queue starts")
        serialQueue.sync {
            let command:Command = Command(commandParam: CommandEnum.Aquire, params: "1," + samples.description)
            let data = tcpManager.sendCommand(command: command)
            spectrumParser = FullRangeInterpolatedSpectrumParser(data: data)
            print("queue finished")
        }
        print("return aquire")
        return spectrumParser!.parse()
    }
    
    func initialize(valueName: String) -> Parameter {
        let command:Command = Command(commandParam: CommandEnum.Initialize, params: "0,"+valueName)
        let data = tcpManager.sendCommand(command: command)
        let parameterParser = ParameterParser(data: data)
        return parameterParser.parse()
    }
    
    func showData(data: [UInt8])-> Parameter{
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
