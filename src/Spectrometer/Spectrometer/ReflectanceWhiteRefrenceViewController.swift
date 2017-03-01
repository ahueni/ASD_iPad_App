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
    
    override func setSpectrum(whiteReferenceSpectrum : FullRangeInterpolatedSpectrum){
        self.currentWhiteRefrence = SpectrumCalculator.calculateDarkCurrentCorrection(spectrum: whiteReferenceSpectrum)
    }
    
    override func updateLineChart() {
        super.updateLineChart()
        if(currentWhiteRefrence == nil){
            DispatchQueue.main.async {
                self.MeasurementLineChart.setAxisValues(min: 0, max: MeasurementMode.Raw.rawValue)
            }
        }
    }
    
    override func goToNextPage() {
        let darkCorrectedWhiteReference = SpectrumCalculator.calculateDarkCurrentCorrection( spectrum: currentWhiteRefrence!)
        
        // Add the white Refrence to the parent VC
        pageContainer!.reflectanceWhiteReference = darkCorrectedWhiteReference
        super.goToNextPage()
    }
    
    // Calculate Reflectance if wr is taken
    override func additionalCalculationOnCurrentSpectrum(){
        if(currentWhiteRefrence != nil){
            currentSpectrum = SpectrumCalculator.calculateReflectance(currentSpectrum: self.currentSpectrum!, whiteReferenceSpectrum: self.currentWhiteRefrence!)
        }
    }
    
}
