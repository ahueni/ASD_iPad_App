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
    
    var aquireLoopOn = false // Indicates if a aquireLoop is running
    
    // stack views
    
    @IBOutlet var mainStackView: UIStackView!
    @IBOutlet var navigationStackView: UIStackView!
    
    @IBOutlet var navigationElements: [UIStackView]!
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setViewOrientation()
    }
    
    internal func setViewOrientation() -> Void {
        let navigationStackWidth = NSLayoutConstraint(item: navigationStackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0.0, constant: 140.0)
        
        if UIDevice.current.orientation.isLandscape {
            mainStackView.axis = .horizontal
            navigationStackView.axis = .vertical
            navigationStackView.alignment = .fill
            navigationStackView.distribution = .equalSpacing
            
            navigationStackView.removeConstraint(navigationStackWidth)
            
            for stackView in navigationElements {
                stackView.distribution = .fill
            }
        }
        
        if UIDevice.current.orientation.isPortrait {
            
            mainStackView.axis = .vertical
            navigationStackView.axis = .horizontal
            navigationStackView.alignment = .top
            navigationStackView.distribution = .fillEqually
            
            navigationStackView.addConstraint(navigationStackWidth)
            
            for stackView in navigationElements {
                stackView.distribution = .fillEqually
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewOrientation()
        //darkCurrent()
    }
    
    @IBAction func startAquire(_ sender: UIButton) {
        aquireLoopOn = !aquireLoopOn
        
        DispatchQueue.global().async {
            while(self.aquireLoopOn){
                self.aquire()
            }
        }
        
    }
    
    @IBAction func optimizeButtonClicked(_ sender: UIButton) {
        aquireLoopOn = false
        CommandManager.sharedInstance.optimize()
    }
    
    func aquire () {
        // Background tasks
        var spectrum = CommandManager.sharedInstance.aquire(samples: (self.appDelegate.config?.sampleCount)!)
        let currentDrift = spectrum.spectrumHeader.vinirHeader.drift
        
        // if dc exists -> do darkcorrection
        if (self.darkCurrentSpectrum != nil){
            InstrumentSettingsCache.sharedInstance.drift = Int(Float(InstrumentSettingsCache.sharedInstance.vinirDarkCurrentCorrection + Double(currentDrift - InstrumentSettingsCache.sharedInstance.darkDrift)))
            print("Drift: " + InstrumentSettingsCache.sharedInstance.drift.description)
            
            spectrum = SpectrumCalculator.calculateDarkCurrentCorrection(spectrum: spectrum, darkCurrentSpectrum: self.darkCurrentSpectrum!)
        }
        
        DispatchQueue.main.async {
            //update ui
            self.lineChart.setAxisValues(min: 0, max: 65000)
            self.updateChart(data: spectrum.getChartData())
        }
    }
    
    @IBAction func darkCurrent(_ sender: Any) {
        aquireLoopOn = false
        CommandManager.sharedInstance.darkCurrent()
    }
    
    @IBAction func openShutter(_ sender: Any) {
        aquireLoopOn = false
        CommandManager.sharedInstance.openShutter()
    }
    
    @IBAction func closeShutter(_ sender: Any) {
        aquireLoopOn = false
        CommandManager.sharedInstance.closeShutter()
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
    
    /*
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
     }*/
    
    func showData(data: [UInt8])-> Parameter{
        let parameterParser = ParameterParser(data: data)
        return parameterParser.parse()
    }
    
    func updateChart(data: LineChartData) -> Void {
        lineChart.data = data
    }
    
    
}
