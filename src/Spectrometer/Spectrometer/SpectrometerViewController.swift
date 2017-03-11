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

class SpectrometerViewController: UIViewController, SelectFiberopticDelegate {
    
    // colors
    let greenButtonColor = UIColor(red:0.09, green:0.76, blue:0.28, alpha:1.00)
    
    // buttons
    @IBOutlet var aquireButton: UIColorButton!
    
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
    
    // disconnect indicator
    var disconnectWhenFinished: Bool = false
    
    // create blur effect for overlay when opening a modal
    let blurEffect = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.light))
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        setViewOrientation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.darkCurrent(self)
        
        // set the serialnumber in the tabbar item title
        self.title = "Spectrometer (" + InstrumentStore.sharedInstance.serialNumber.description + ")"
        
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
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ViewStore.sharedInstance.aquireLoop = false
    }
    
    @IBAction func startAquire(_ sender: UIButton) {
        startAquire()
    }
    
    @IBAction func changeAquireMode(_ sender: RadioButton) {
        
        // stop actual aquire mode
        ViewStore.sharedInstance.aquireLoop = false
        
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
        ViewStore.sharedInstance.aquireLoop = false
        
        // take dark current
        let darkCurrentSampleCount = ViewStore.sharedInstance.instrumentConfiguration.sampleCountDarkCurrent
        CommandManager.sharedInstance.darkCurrent(sampleCount: darkCurrentSampleCount)
        
        // restart darkCurrent timer
        ViewStore.sharedInstance.restartDarkCurrentTimer()
        
        // after a dark current evaluate measurement modes
        activateRadianceMode()
        activateReflectanceMode()
        startAquire()
    }
    
    @IBAction func whiteReference(_ sender: UIButton) {
        // stopp aquire loop
        ViewStore.sharedInstance.aquireLoop = false
        
        // first take a new dark current
        let darkCurrentSampleCount = ViewStore.sharedInstance.instrumentConfiguration.sampleCountDarkCurrent
        CommandManager.sharedInstance.darkCurrent(sampleCount: darkCurrentSampleCount)
        
        // take white reference and calculate dark current correction
        let whiteRefSampleCount = ViewStore.sharedInstance.instrumentConfiguration.sampleCountWhiteRefrence
        let whiteRefWithoutDarkCurrent = CommandManager.sharedInstance.aquire(samples: whiteRefSampleCount)
        InstrumentStore.sharedInstance.whiteReferenceSpectrum = SpectrumCalculator.calculateDarkCurrentCorrection(spectrum: whiteRefWithoutDarkCurrent)
        
        // restart whiteReference timer
        ViewStore.sharedInstance.restartWhiteReferenceTimer()
        
        // activate reflectance mode
        activateReflectanceMode()
        
        // after white reference start reflectance mode
        measurementMode = .Reflectance
        reflectanceRadioButton.unselectAlternateButtons()
        startAquire()
    }
    
    @IBAction func optimizeInstrument(_ sender: UIColorButton) {
        
        // stopp aquire loop
        ViewStore.sharedInstance.aquireLoop = false
        
        // optimizeInstrument
        CommandManager.sharedInstance.optimize()
        
        // reset all resetTimers
        ViewStore.sharedInstance.resetTimers()
        
        // remove white reference and handle buttons
        InstrumentStore.sharedInstance.whiteReferenceSpectrum = nil
        if measurementMode == .Reflectance {
            measurementMode = .Raw
            rawRadioButton.unselectAlternateButtons()
        }
        reflectanceRadioButton.isEnabled = false
        whiteReferenceTimerLabel.text = "Never taken"
        
        // retake dark current
        let darkCurrentSampleCount = ViewStore.sharedInstance.instrumentConfiguration.sampleCountDarkCurrent
        CommandManager.sharedInstance.darkCurrent(sampleCount: darkCurrentSampleCount)
        
        // after optimization start agian with aquire
        startAquire()
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
        if (!ViewStore.sharedInstance.aquireLoop) {
            finishedAquireLoopHandler()
        }
        
        // stopp aquire loop and set disconnect indicator
        ViewStore.sharedInstance.aquireLoop = false
        self.disconnectWhenFinished = true
    }
    
    internal func startAquire() {
        ViewStore.sharedInstance.aquireLoop = !ViewStore.sharedInstance.aquireLoop
        
        DispatchQueue.main.async {
            // change button title
            if ViewStore.sharedInstance.aquireLoop {
                self.aquireButton.setTitle("Stop Aquire", for: .normal)
                self.aquireButton.background = UIColor.red
            } else {
                self.aquireButton.setTitle("Start Aquire", for: .normal)
                self.aquireButton.background = self.greenButtonColor
            }
        }
        
        // don't start a new aquire queue when its false -> the button is pressed to stopp it
        // without this check a second aquireQueue will be started only to end immediately
        if !ViewStore.sharedInstance.aquireLoop { return }
        
        DispatchQueue(label: "aquireQueue").async {
            print("AquireLoop started...")
            while(ViewStore.sharedInstance.aquireLoop){
                
                // collect spectrum
                let sampleCount = ViewStore.sharedInstance.instrumentConfiguration.sampleCount
                var spectrum = CommandManager.sharedInstance.aquire(samples: sampleCount)
                
                // calculate dark current if selected on view
                spectrum = SpectrumCalculator.calculateDarkCurrentCorrection(spectrum: spectrum)
                
                // calculate reflectance or radiance and change axis of line chart
                switch self.measurementMode {
                case .Raw: break
                case .Reflectance:
                    let whiteReference = InstrumentStore.sharedInstance.whiteReferenceSpectrum!
                    spectrum = SpectrumCalculator.calculateReflectance(currentSpectrum: spectrum, whiteReferenceSpectrum: whiteReference)
                case .Radiance:
                    spectrum.spectrumBuffer = SpectrumCalculator.calculateRadiance(spectrum: spectrum)
                }
                
                // update chart data
                let chartDataSet = spectrum.spectrumBuffer.getChartData()
                let lineChartDataSet = LineChartData(dataSet: chartDataSet)
                self.updateChart(chartData: lineChartDataSet, measurementMode: self.measurementMode)
                
            }
            CommandManager.sharedInstance.addCancelCallback(callBack: self.finishedAquireLoopHandler)
            print("AquireLoop stopped...")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartTestSeriesSegue" {
            ViewStore.sharedInstance.aquireLoop = false
        }
    }
    
    internal func finishedAquireLoopHandler() {
        // switch back to UI thread
        DispatchQueue.main.async {
            
            self.aquireButton.setTitle("Start Aquire", for: .normal)
            self.aquireButton.background = self.greenButtonColor
            
            // if disconnect button was pressed -> return to config view
            if (self.disconnectWhenFinished) {
                
                // close connection
                TcpManager.sharedInstance.disconnect()
                
                // redirect to SpectrometerConfig view
                let initialViewController = self.storyboard?.instantiateViewController(withIdentifier: "SpectrometerConfig") as! UITabBarController
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.window?.rootViewController = initialViewController
                appDelegate.window?.makeKeyAndVisible()
                
                // remove application wide settings when disconnect they will be recreate on connection
                InstrumentStore.sharedInstance.dispose()
                ViewStore.sharedInstance.resetTimers()
                
                
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
        if InstrumentStore.sharedInstance.whiteReferenceSpectrum != nil && InstrumentStore.sharedInstance.darkCurrent != nil {
            reflectanceRadioButton.isEnabled = true
        } else {
            reflectanceRadioButton.isEnabled = false
        }
    }
    
    internal func activateRadianceMode() {
        // check if a foreoptic is slected
        if let selectedForeOptic = InstrumentStore.sharedInstance.selectedForeOptic {
            foreOpticLabel.text = selectedForeOptic.name
            
            // check if darkCurrent is taken before activate radiance mode
            if InstrumentStore.sharedInstance.darkCurrent != nil {
                radianceRadioButton.isEnabled = true
            }
        } else {
            foreOpticLabel.text = "Please select a Foreoptic to activate Radiance mode"
            radianceRadioButton.isEnabled = false
        }
    }
    
    internal func didSelectFiberoptic(fiberoptic: CalibrationFile) {
        InstrumentStore.sharedInstance.selectedForeOptic = fiberoptic
        activateRadianceMode()
    }
    
    internal func updateDarkCurrentTimerLabel() {
        if let darkCurrentStartTime = ViewStore.sharedInstance.darkCurrentStartTime {
            let elapsedTime = NSDate.timeIntervalSinceReferenceDate - darkCurrentStartTime
            darkCurrentTimerLabel.text = elapsedTime.getHHMMSS()
        }
    }
    
    internal func updateWhiteReferenceTimerLabel() {
        if let whiteReferenceStartTime = ViewStore.sharedInstance.whiteReferenceStartTime {
            let elapsedTime = NSDate.timeIntervalSinceReferenceDate - whiteReferenceStartTime
            whiteReferenceTimerLabel.text = elapsedTime.getHHMMSS()
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
