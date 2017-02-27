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

enum MeasurementMode {
    
    case Raw
    case Reflectance
    case Radiance
    
}

class AquireViewController: UIViewController, SelectFiberopticDelegate {
    
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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let tcpManager: TcpManager = (UIApplication.shared.delegate as! AppDelegate).tcpManager!
    
    // stack views
    @IBOutlet var mainStackView: UIStackView!
    @IBOutlet var navigationStackView: UIStackView!
    @IBOutlet var navigationElements: [UIStackView]!
    
    var measurementMode: MeasurementMode = MeasurementMode.Raw
    var whiteReferenceSpectrum: FullRangeInterpolatedSpectrum?
    var selectedForeOptic: CalibrationFile?
    
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
        
        // select a default foreOptic file
        let allForeOpticFiles = self.appDelegate.config?.fiberOpticCalibrations?.allObjects as! [CalibrationFile]
        selectedForeOptic = allForeOpticFiles.first
        activateRadianceMode()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setViewOrientation()
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
        CommandManager.sharedInstance.darkCurrent()
        self.lineChart.setAxisValues(min: 0, max: 65000)
        self.lineChart.data = InstrumentSettingsCache.sharedInstance.darkCurrent?.getChartData()
    }
    
    @IBAction func whiteReference(_ sender: UIButton) {
        // stopp aquire loop
        InstrumentSettingsCache.sharedInstance.aquireLoop = false
        
        // first take a new dark current
        CommandManager.sharedInstance.darkCurrent()
        
        // take white reference and calculate dark current correction
        let whiteRefWithoutDarkCurrent = CommandManager.sharedInstance.aquire(samples: 10)
        whiteReferenceSpectrum = SpectrumCalculator.calculateDarkCurrentCorrection(spectrum: whiteRefWithoutDarkCurrent)
        
        // display the actual white reference to chart
        self.lineChart.setAxisValues(min: 0, max: 65000)
        self.lineChart.data = whiteReferenceSpectrum?.getChartData()
        
        activateReflectanceMode()
        
    }
    
    @IBAction func optimizeButtonClicked(_ sender: UIButton) {
        InstrumentSettingsCache.sharedInstance.aquireLoop = false
        CommandManager.sharedInstance.optimize()
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
    
    internal func startAquire() {
        
        InstrumentSettingsCache.sharedInstance.aquireLoop = !InstrumentSettingsCache.sharedInstance.aquireLoop
        
        // change button title
        if InstrumentSettingsCache.sharedInstance.aquireLoop {
            aquireButton.setTitle("Stop Aquire", for: .normal)
        } else {
            aquireButton.setTitle("Start Aquire", for: .normal)
        }
        
        // don't start a new aquire queue when its false -> the button is pressed to stopp it
        // without this check a second aquireQueue will be started only to end immediately
        if !InstrumentSettingsCache.sharedInstance.aquireLoop { return }
        
        DispatchQueue(label: "aquireQueue").async {
            print("AquireLoop started...")
            while(InstrumentSettingsCache.sharedInstance.aquireLoop){
                
                // collect spectrum
                var spectrum = CommandManager.sharedInstance.aquire(samples: (self.appDelegate.config?.sampleCount)!)
                
                // calculate dark current if selected on view
                spectrum = SpectrumCalculator.calculateDarkCurrentCorrection(spectrum: spectrum)
                
                // calculate reflectance or radiance and change axis of line chart
                switch self.measurementMode {
                case .Raw:
                    self.lineChart.setAxisValues(min: 0, max: 65000)
                case .Reflectance:
                    self.lineChart.setAxisValues(min: -1, max: 4)
                    spectrum = SpectrumCalculator.calculateReflectance(currentSpectrum: spectrum, whiteReferenceSpectrum: self.whiteReferenceSpectrum!)
                case .Radiance:
                    self.lineChart.setAxisValues(min: -1, max: 4)
                    //spectrum = SpectrumCalculator.calculateRadiance()
                }
                
                // update user interface in main thread
                DispatchQueue.main.async {
                    self.lineChart.data = spectrum.getChartData()
                }
                
            }
            self.aquireButton.setTitle("Start Aquire", for: .normal)
            print("AquireLoop stopped...")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "StartTestSeriesSegue"{
            InstrumentSettingsCache.sharedInstance.aquireLoop = false
        }
    }
    
    internal func activateReflectanceMode() {
        
        if whiteReferenceSpectrum != nil {
            reflectanceRadioButton.isEnabled = true
        } else {
            reflectanceRadioButton.isEnabled = false
        }
        
    }
    
    internal func activateRadianceMode() {
        
        if let selectedForeOptic = selectedForeOptic {
            foreOpticLabel.text = selectedForeOptic.name
            radianceRadioButton.isEnabled = true
        } else {
            foreOpticLabel.text = "Please select a Foreoptic to activate Radiance mode"
            radianceRadioButton.isEnabled = false
        }
        
    }
    
    internal func didSelectFiberoptic(fiberoptic: CalibrationFile) {
        selectedForeOptic = fiberoptic
        activateRadianceMode()
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
