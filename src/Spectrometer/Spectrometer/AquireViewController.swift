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
    var vinirDarkCurrentCorrection: Double = 0
    var aquireLoopOn = false // Indicates if a aquireLoop is running
    
    var darkDrift: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        darkCurrent()
    }
    
    @IBAction func startAquire(_ sender: UIButton) {
        aquireLoopOn = !aquireLoopOn
        
        DispatchQueue.global().async {
            while(self.aquireLoopOn){
                self.aquireWithDarkCorrection()
            }
        }
        
    }
    @IBAction func optimizeButtonClicked(_ sender: UIButton) {
        aquireLoopOn = false
        CommandManager.sharedInstance.optimize()
    }
    
    func aquireWithDarkCorrection () {
            // Background tasks
            let spectrum = CommandManager.sharedInstance.aquire(samples: (self.appDelegate.config?.sampleCount)!)
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
        //CommandManager.sharedInstance.aquire(samples: 10)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartTestSeriesSegue"{
            aquireLoopOn = false
        }
    }
    
    func computeReflectance(){
        startingWaveLength = Int(CommandManager.sharedInstance.initialize(valueName: "StartingWavelength").value)
        endingWaveLength = Int(CommandManager.sharedInstance.initialize(valueName: "EndingWavelength").value)
        
        let refrenceSpectrum = CommandManager.sharedInstance.aquire(samples: 10)
        
        //darkCurrent(self)
        let aquireData = CommandManager.sharedInstance.aquire(samples: 10)
        
        // Compute Reflectance
        for i in 0 ... ((endingWaveLength + 1) - startingWaveLength){
            aquireData.spectrumBuffer[i] = aquireData.spectrumBuffer[i] / refrenceSpectrum.spectrumBuffer[i]
        }
    }
    
    /*
    func saveSpectrum(spectrum: FullRangeInterpolatedSpectrum, whiteRefrenceSpectrum: FullRangeInterpolatedSpectrum){
        let path = ("~/Documents/test.txt" as NSString).expandingTildeInPath
        
        let fw = FileWriter(path: path)
        let fileHandle:FileHandle = fw.write(spectrum: spectrum, whiteRefrenceSpectrum: spectrum)
        
        let dataBuffer = [UInt8](FileManager().contents(atPath: path)!)
        let fileParser = SpectralFileParser(data: dataBuffer)
        
        do{
            try fileParser.parse()
            print("File succesfully parsed!")
        }
        catch{
            
            print("File not parsed!")
        }

    }*/
    
    
    
    func darkCurrent() -> Void{
        startingWaveLength = Int(CommandManager.sharedInstance.initialize(valueName: "StartingWavelength").value)
        //endingWaveLength = initialize(valueName: "EndingWavelength").value
        //vinirStartingWavelength = initialize(valueName: "VStartingWavelength").value
        vinirEndingWavelength = Int(CommandManager.sharedInstance.initialize(valueName: "VEndingWavelength").value)
        vinirDarkCurrentCorrection = CommandManager.sharedInstance.initialize(valueName: "VDarkCurrentCorrection").value
        
        CommandManager.sharedInstance.optimize()
        
        closeShutter()
        darkCurrentSpectrum = CommandManager.sharedInstance.aquire(samples: 10)
        darkDrift = (darkCurrentSpectrum?.spectrumHeader.vHeader.drift)!
        openShutter()
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
