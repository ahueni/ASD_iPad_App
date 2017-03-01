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
    
    // colors
    let greenButtonColor = UIColor(red:0.09, green:0.76, blue:0.28, alpha:1.00)
    
    // buttons
    @IBOutlet var aquireButton: UIButton!
    
    @IBOutlet var rawRadioButton: RadioButton!
    @IBOutlet var reflectanceRadioButton: RadioButton!
    @IBOutlet var radianceRadioButton: RadioButton!
    
    // foreoptic
    @IBOutlet var foreOpticButton: UIColorButton!
    @IBOutlet var foreOpticLabel: UILabel!
    
    // chart
    @IBOutlet var lineChart: SpectrumLineChartView!
    
    // dc and wr timer labels
    @IBOutlet var darkCurrentTimerLabel: UILabel!
    @IBOutlet var whiteReferenceTimerLabel: UILabel!
    
    // stack views
    @IBOutlet var mainStackView: UIStackView!
    @IBOutlet var navigationStackView: UIStackView!
    @IBOutlet var navigationElements: [UIStackView]!
    
    var measurementMode: MeasurementMode = MeasurementMode.Raw
    var whiteReferenceSpectrum: FullRangeInterpolatedSpectrum?
    
    // disconnect indicator
    var disconnectWhenFinished: Bool = false
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setViewOrientation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init radio buttons
        rawRadioButton.alternateButton = [reflectanceRadioButton, radianceRadioButton]
        reflectanceRadioButton.alternateButton = [rawRadioButton, radianceRadioButton]
        radianceRadioButton.alternateButton = [rawRadioButton, reflectanceRadioButton]
        
        // register dc and wr labels for update notifications
        NotificationCenter.default.addObserver(self, selector: #selector(updateDarkCurrentTimerLabel), name: .darkCurrentTimer, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateWhiteReferenceTimerLabel), name: .whiteReferenceTimer, object: nil)
        
        // activateRadianceMode -> actually nothing happens because no dark current is taken
        activateRadianceMode()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViewOrientation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        InstrumentSettingsCache.sharedInstance.aquireLoop = false
    }
    
    @IBAction func startAquire(_ sender: UIButton) {
        startAquire()
    }
    
    @IBAction func changeAquireMode(_ sender: RadioButton) {
        
        // stop actual aquire mode
        InstrumentSettingsCache.sharedInstance.aquireLoop = false
        
        // set new mode
        switch sender.tag {
        case 0:
            measurementMode = MeasurementMode.Raw
        case 1:
            measurementMode = MeasurementMode.Reflectance
        case 2:
            measurementMode = MeasurementMode.Radiance
        default:
            measurementMode = MeasurementMode.Raw
        }
        
        // restart aquire in new mode
        startAquire()
        
    }
    
    
    @IBAction func darkCurrent(_ sender: Any) {
        InstrumentSettingsCache.sharedInstance.aquireLoop = false
        
        // take dark current
        let darkCurrentSampleCount = InstrumentSettingsCache.sharedInstance.instrumentConfiguration.sampleCountDarkCurrent
        CommandManager.sharedInstance.darkCurrent(sampleCount: darkCurrentSampleCount)
        
        // update chart data
        self.updateChart(chartData: (InstrumentSettingsCache.sharedInstance.darkCurrent?.getChartData())!, measurementMode: .Raw)
        
        // restart darkCurrent timer
        InstrumentSettingsCache.sharedInstance.restartDarkCurrentTimer()
        
        // after a dark current evaluate measurement modes
        activateRadianceMode()
        activateReflectanceMode()
    }
    
    @IBAction func whiteReference(_ sender: UIButton) {
        // stopp aquire loop
        InstrumentSettingsCache.sharedInstance.aquireLoop = false
        
        // first take a new dark current
        let darkCurrentSampleCount = InstrumentSettingsCache.sharedInstance.instrumentConfiguration.sampleCountDarkCurrent
        CommandManager.sharedInstance.darkCurrent(sampleCount: darkCurrentSampleCount)
        
        // take white reference and calculate dark current correction
        let whiteRefSampleCount = InstrumentSettingsCache.sharedInstance.instrumentConfiguration.sampleCountDarkCurrent
        let whiteRefWithoutDarkCurrent = CommandManager.sharedInstance.aquire(samples: whiteRefSampleCount)
        whiteReferenceSpectrum = SpectrumCalculator.calculateDarkCurrentCorrection(spectrum: whiteRefWithoutDarkCurrent)
        
        // update chart data
        updateChart(chartData: (whiteReferenceSpectrum?.getChartData())!, measurementMode: .Raw)
        
        // restart whiteReference timer
        InstrumentSettingsCache.sharedInstance.restartWhiteReferenceTimer()
        
        // activate reflectance mode
        activateReflectanceMode()
    }
    
    @IBAction func selectFiberOptic(_ sender: UIColorButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectFiberOpticTableViewController") as! SelectFiberOpticTableViewController
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        let popover = vc.popoverPresentationController!
        popover.permittedArrowDirections = [.left, .up]
        popover.sourceView = sender
        popover.sourceRect = sender.bounds
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func disconnectSpectrometer(_ sender: UIColorButton) {
        
        // if no loop is active -> disconnect otherwise wait until loop has ended
        if (!InstrumentSettingsCache.sharedInstance.aquireLoop) {
            finishedAquireLoopHandler()
        }
        
        // stopp aquire loop and set disconnect indicator
        InstrumentSettingsCache.sharedInstance.aquireLoop = false
        self.disconnectWhenFinished = true
        
    }
    
    internal func startAquire() {
        
        InstrumentSettingsCache.sharedInstance.aquireLoop = !InstrumentSettingsCache.sharedInstance.aquireLoop
        
        // change button title
        if InstrumentSettingsCache.sharedInstance.aquireLoop {
            aquireButton.setTitle("Stop Aquire", for: .normal)
            aquireButton.backgroundColor = UIColor.red
        } else {
            aquireButton.setTitle("Start Aquire", for: .normal)
            aquireButton.backgroundColor = greenButtonColor
        }
        
        // don't start a new aquire queue when its false -> the button is pressed to stopp it
        // without this check a second aquireQueue will be started only to end immediately
        if !InstrumentSettingsCache.sharedInstance.aquireLoop { return }
        
        DispatchQueue(label: "aquireQueue").async {
            print("AquireLoop started...")
            while(InstrumentSettingsCache.sharedInstance.aquireLoop){
                
                // collect spectrum
                let sampleCount = InstrumentSettingsCache.sharedInstance.instrumentConfiguration.sampleCount
                var spectrum = CommandManager.sharedInstance.aquire(samples: sampleCount)
                
                // calculate dark current if selected on view
                spectrum = SpectrumCalculator.calculateDarkCurrentCorrection(spectrum: spectrum)
                
                // calculate reflectance or radiance and change axis of line chart
                switch self.measurementMode {
                case .Raw: break
                case .Reflectance:
                    spectrum = SpectrumCalculator.calculateReflectance(currentSpectrum: spectrum, whiteReferenceSpectrum: self.whiteReferenceSpectrum!)
                case .Radiance:
                    spectrum.spectrumBuffer = SpectrumCalculator.calculateRadiance(spectrum: spectrum)
                }
                
                // update chart data
                self.updateChart(chartData: spectrum.getChartData(), measurementMode: self.measurementMode)
                
            }
            CommandManager.sharedInstance.addCancelCallback(callBack: self.finishedAquireLoopHandler)
            print("AquireLoop stopped...")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartTestSeriesSegue"{
            InstrumentSettingsCache.sharedInstance.aquireLoop = false
        }
    }
    
    internal func finishedAquireLoopHandler() {
        
        // switch back to UI thread
        DispatchQueue.main.async {
            
            self.aquireButton.setTitle("Start Aquire", for: .normal)
            self.aquireButton.backgroundColor = self.greenButtonColor
            
            // if disconnect button was pressed -> return to config view
            if (self.disconnectWhenFinished) {
                
                // close connection
                TcpManager.sharedInstance.close()
                
                // redirect to SpectrometerConfig view
                let initialViewController = self.storyboard?.instantiateViewController(withIdentifier: "SpectrometerConfig") as! UITabBarController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = initialViewController
                appDelegate.window?.makeKeyAndVisible()
                
            }
            
            
        }
        
    }
    
    internal func updateChart(chartData: LineChartData, measurementMode: MeasurementMode) {
        
        // switch to UI thread
        DispatchQueue.main.async {
            
            // set chart axis
            switch measurementMode {
            case .Raw:
                self.lineChart.setAxisValues(min: 0, max: measurementMode.rawValue)
            case .Reflectance:
                self.lineChart.setAxisValues(min: 0, max: measurementMode.rawValue)
            case .Radiance:
                self.lineChart.setAxisValues(min: 0, max: measurementMode.rawValue)
            }
            
            // update chart data
            self.lineChart.data = chartData
            
        }
        
        
    }
    
    internal func activateReflectanceMode() {
        
        // check if white reference and dark current available
        if whiteReferenceSpectrum != nil && InstrumentSettingsCache.sharedInstance.darkCurrent != nil {
            reflectanceRadioButton.isEnabled = true
        } else {
            reflectanceRadioButton.isEnabled = false
        }
        
    }
    
    internal func activateRadianceMode() {
        
        // check if a foreoptic is slected
        if let selectedForeOptic = InstrumentSettingsCache.sharedInstance.selectedForeOptic {
            
            foreOpticLabel.text = selectedForeOptic.name
            
            // check if darkCurrent is taken before activate radiance mode
            if InstrumentSettingsCache.sharedInstance.darkCurrent != nil {
                radianceRadioButton.isEnabled = true
            }
            
        } else {
            foreOpticLabel.text = "Please select a Foreoptic to activate Radiance mode"
            radianceRadioButton.isEnabled = false
        }
        
    }
    
    internal func didSelectFiberoptic(fiberoptic: CalibrationFile) {
        InstrumentSettingsCache.sharedInstance.selectedForeOptic = fiberoptic
        activateRadianceMode()
    }
    
    internal func updateDarkCurrentTimerLabel() {
        
        if let darkCurrentStartTime = InstrumentSettingsCache.sharedInstance.darkCurrentStartTime {
            let elapsedTime = NSDate.timeIntervalSinceReferenceDate - darkCurrentStartTime
            darkCurrentTimerLabel.text = Int(elapsedTime).description
        }
        
    }
    
    internal func updateWhiteReferenceTimerLabel() {
        
        if let whiteReferenceStartTime = InstrumentSettingsCache.sharedInstance.whiteReferenceStartTime {
            let elapsedTime = NSDate.timeIntervalSinceReferenceDate - whiteReferenceStartTime
            whiteReferenceTimerLabel.text = Int(elapsedTime).description
        }
        
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
    
    
}
