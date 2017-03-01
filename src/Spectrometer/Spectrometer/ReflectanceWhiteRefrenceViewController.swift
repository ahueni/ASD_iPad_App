//
//  WhiteRefrenceViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 30.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ReflectanceWhiteRefrenceViewController : BaseWhiteReferenceViewController {
    
    var currentWhiteRefrence : FullRangeInterpolatedSpectrum? = nil
    
    override func setSpectrum(){
        let whiteRefSampleCount = InstrumentSettingsCache.sharedInstance.instrumentConfiguration.sampleCountWhiteRefrence
        let whiteReference = CommandManager.sharedInstance.aquire(samples: whiteRefSampleCount)
        self.currentWhiteRefrence = SpectrumCalculator.calculateDarkCurrentCorrection(spectrum: whiteReference)
    }
    
    override func updateLineChart(spectrum: FullRangeInterpolatedSpectrum) {
        // Show the LineChart if no whiteRefrence was taken. Show the reflectance otherwise
        currentWhiteRefrence == nil ? super.updateLineChart(spectrum: currentSpectrum!) : self.showReflectance()
    }
    
    override func goToNextPage() {
        
        let darkCorrectedWhiteReference = SpectrumCalculator.calculateDarkCurrentCorrection( spectrum: currentWhiteRefrence!)
        
        writeFileAsync(spectrum: darkCorrectedWhiteReference, isWhiteReference: true)
        
        // Add the white Refrence to the parent VC
        pageContainer!.whiteRefrenceBeforeSpectrumList.append(darkCorrectedWhiteReference)
        super.goToNextPage()
    }
    
    // Show Reflectance => WhiteRefrence / Current spectrum
    func showReflectance() {
        DispatchQueue.main.async {
            //update ui
            self.MeasurementLineChart.setAxisValues(min: 0, max: 5)
            
            let reflectanceSpectrum = SpectrumCalculator.calculateReflectance(currentSpectrum: self.currentSpectrum!, whiteReferenceSpectrum: self.currentWhiteRefrence!)
            
            DispatchQueue.main.async {
                self.MeasurementLineChart.data = reflectanceSpectrum.getChartData()
            }
        }
    }
    
}
