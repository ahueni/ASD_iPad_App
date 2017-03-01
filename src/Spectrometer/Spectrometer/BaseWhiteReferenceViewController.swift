//
//  BaseWhiteRefrenceViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 24.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class BaseWhiteReferenceViewController : BaseMeasurementModal {
    
    var currentSpectrum : FullRangeInterpolatedSpectrum? = nil // the actual Measurment
    var whiteRefrencePage : WhiteReferencePage! // currentPage
    
    @IBOutlet var progressBar: CustomProgressBar!
    @IBOutlet weak var startWhiteRefrenceButton: LoadingButton!
    @IBOutlet weak var nextButton: UIBlueButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        whiteRefrencePage = pageContainer.currentPage as! WhiteReferencePage
        progressBar?.initialize(total: whiteRefrencePage.whiteReferenceCount)
        
        // start aquire data
        InstrumentSettingsCache.sharedInstance.cancelMeasurment = false
        DispatchQueue.global().async {
            while(!InstrumentSettingsCache.sharedInstance.cancelMeasurment){
                self.aquire()
            }
        }
    }
    
    func aquire() {
        // Background tasks
        let sampleCount = InstrumentSettingsCache.sharedInstance.instrumentConfiguration.sampleCount
        let aquiredSpectrum = CommandManager.sharedInstance.aquire(samples: sampleCount)
        currentSpectrum = SpectrumCalculator.calculateDarkCurrentCorrection(spectrum: aquiredSpectrum)
        self.updateLineChart(spectrum: self.currentSpectrum!)
    }
    
    @IBAction func takeWhiteRefrence(_ sender: UIButton) {
        startWhiteRefrenceButton.showLoading()
        nextButton.isEnabled = false
        InstrumentSettingsCache.sharedInstance.cancelMeasurment = false
        
        DispatchQueue.global().async {
            for i in 0...self.whiteRefrencePage.whiteReferenceCount-1
            {
                if(InstrumentSettingsCache.sharedInstance.cancelMeasurment)
                {
                    return
                }
                
                self.updateProgressBar(measurmentCount: i, statusText: "Bereite nächste Messung vor")
                sleep(UInt32(self.whiteRefrencePage.whiteReferenceDelay)) // Wait two second before starting the next measurment
                self.updateProgressBar(measurmentCount: i, statusText: "Messe...")
                self.setSpectrum()
                self.updateProgressBar(measurmentCount: i+1, statusText: "Messung beendet")
                sleep(UInt32(self.whiteRefrencePage.whiteReferenceDelay)) //Wait two second
            }
            DispatchQueue.main.async {
                self.startWhiteRefrenceButton.hideLoading()
                self.startWhiteRefrenceButton.setTitle("Retake white Refrence", for: .normal)
                self.nextButton.isEnabled = true
            }
        }
    }
    
    // Swift does not support abstract classes. This is the only way to make sure the derived classes do override this method
    func setSpectrum(){
        fatalError("Must Override")
    }
    
    func updateProgressBar(measurmentCount:Int, statusText:String)
    {
        if(progressBar == nil)
        {return}
        DispatchQueue.main.async {
            self.progressBar.updateProgressBar(actual: measurmentCount, statusText: statusText)
        }
    }
    
}
