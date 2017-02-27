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

class AquireViewController: UIViewController, SelectFiberopticDelegate {
    
    // buttons
    @IBOutlet var aquireButton: UIButton!
    
    // chart
    @IBOutlet var lineChart: SpectrumLineChartView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let tcpManager: TcpManager = (UIApplication.shared.delegate as! AppDelegate).tcpManager!
    
    var whiteReferenceSpectrum: FullRangeInterpolatedSpectrum? = nil
    
    // stack views
    
    @IBOutlet var mainStackView: UIStackView!
    @IBOutlet var navigationStackView: UIStackView!
    
    @IBOutlet var navigationElements: [UIStackView]!
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setViewOrientation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViewOrientation()
    }
    
    @IBAction func startAquire(_ sender: UIButton) {
        startAquire()
    }
    
    @IBAction func optimizeButtonClicked(_ sender: UIButton) {
        InstrumentSettingsCache.sharedInstance.aquireLoop = false
        CommandManager.sharedInstance.optimize()
    }
    
    @IBAction func selectFiberOptic(_ sender: UIColorButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectFiberOpticTableViewController") as!SelectFiberOpticTableViewController
        vc.delegate = self
        
        vc.modalPresentationStyle = .popover
        
        let popover = vc.popoverPresentationController!
        
        popover.permittedArrowDirections = [.left, .up]
        popover.sourceView = sender
        popover.sourceRect = sender.bounds
        
        self.present(vc, animated: true, completion: nil)
    }
    
    internal func startAquire() {
        
        InstrumentSettingsCache.sharedInstance.aquireLoop = !InstrumentSettingsCache.sharedInstance.aquireLoop
        
        // change button title
        if InstrumentSettingsCache.sharedInstance.aquireLoop {
            aquireButton.setTitle("Stop Aquire", for: .normal)
        } else {
            aquireButton.setTitle("Start Aquire", for: .normal)
        }
        
        // don't start a new aquire queue when its false -> the button is pressed to stopp it
        // without this check a second aquireQueue will be started only to end emediatly
        if !InstrumentSettingsCache.sharedInstance.aquireLoop { return }
        
        DispatchQueue(label: "aquireQueue").async {
            print("AquireLoop started...")
            while(InstrumentSettingsCache.sharedInstance.aquireLoop){
                self.aquire()
            }
            print("AquireLoop stopped...")
        }
        
    }
    
    internal func aquire () {
        
        var spectrum = CommandManager.sharedInstance.aquire(samples: (self.appDelegate.config?.sampleCount)!)
        spectrum = SpectrumCalculator.calculateDarkCurrentCorrection(spectrum: spectrum)
        
        DispatchQueue.main.async {
            //update ui
            self.lineChart.setAxisValues(min: 0, max: 65000)
            self.updateChart(data: spectrum.getChartData())
        }
    }
    
    @IBAction func darkCurrent(_ sender: Any) {
        InstrumentSettingsCache.sharedInstance.aquireLoop = false
        CommandManager.sharedInstance.darkCurrent()
        startAquire()
    }
    
    @IBAction func whiteReference(_ sender: UIButton) {
        InstrumentSettingsCache.sharedInstance.aquireLoop = false
        //CommandManager.sharedInstance.aquire(samples: 10)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartTestSeriesSegue"{
            InstrumentSettingsCache.sharedInstance.aquireLoop = false
        }
    }
    
    internal func didSelectFiberoptic(fiberoptic: CalibrationFile) {
        print("fiberoptic selected...")
        
    }
    
    internal func setViewOrientation() -> Void {
        
        if UIDevice.current.orientation.isLandscape {
            mainStackView.axis = .horizontal
            navigationStackView.axis = .vertical
            navigationStackView.alignment = .fill
            navigationStackView.distribution = .equalSpacing
            
            for stackView in navigationElements {
                stackView.distribution = .fill
            }
        }
        
        if UIDevice.current.orientation.isPortrait {
            
            mainStackView.axis = .vertical
            navigationStackView.axis = .horizontal
            navigationStackView.alignment = .top
            navigationStackView.distribution = .fillEqually
            
            for stackView in navigationElements {
                stackView.distribution = .fillEqually
            }
        }
        
        self.view.layoutSubviews()
        
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
