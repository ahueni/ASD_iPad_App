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
        //Aquire
        let sampleCount = InstrumentSettingsCache.sharedInstance.instrumentConfiguration.sampleCount
        let aquiredSpectrum = CommandManager.sharedInstance.aquire(samples: sampleCount)
        
        // DC Correction
        currentSpectrum = SpectrumCalculator.calculateDarkCurrentCorrection(spectrum: aquiredSpectrum)
        //Additional Calculations for example convert dn to radiance
        additionalCalculationOnCurrentSpectrum()
        
        lineChartDataContainer.currentLineChart = currentSpectrum!.spectrumBuffer.getChartData(lineWidth: 1)
        //update Chart
        self.updateLineChart()
    }
    
    func additionalCalculationOnCurrentSpectrum(){
        fatalError("Must override")
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
                
                //Aquire spectrum
                self.updateProgressBar(measurmentCount: i, statusText: "Measure...")
                let sampleCount = InstrumentSettingsCache.sharedInstance.instrumentConfiguration.sampleCount
                let spectrum = CommandManager.sharedInstance.aquire(samples: sampleCount)
                let darkCorrectedSpectrum = SpectrumCalculator.calculateDarkCurrentCorrection(spectrum: spectrum)
                self.setSpectrum(whiteReferenceSpectrum: darkCorrectedSpectrum)
                
                //update progress and wait delay
                self.updateProgressBar(measurmentCount: i+1, statusText: "Waiting...")
                sleep(UInt32(self.whiteRefrencePage.whiteReferenceDelay))
            }
            
            //update UI
            DispatchQueue.main.async {
                self.startWhiteRefrenceButton.hideLoading()
                self.startWhiteRefrenceButton.setTitle("Retake white Refrence", for: .normal)
                self.nextButton.isEnabled = true
            }
        }
    }
    
    // Swift does not support abstract classes. This is the only way to make sure the derived classes do override this method
    func setSpectrum(whiteReferenceSpectrum : FullRangeInterpolatedSpectrum){
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
