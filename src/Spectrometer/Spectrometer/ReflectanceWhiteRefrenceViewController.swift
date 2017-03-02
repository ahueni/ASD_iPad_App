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
    
    override func setSpectrum(whiteReferenceSpectrum : FullRangeInterpolatedSpectrum){
        self.pageContainer!.reflectanceWhiteReference = whiteReferenceSpectrum
    }
    
    override func updateLineChart() {
        super.updateLineChart()
        if(pageContainer!.reflectanceWhiteReference == nil){
            DispatchQueue.main.async {
                self.MeasurementLineChart.setAxisValues(min: 0, max: MeasurementMode.Raw.rawValue)
            }
        }
    }
    
    // Calculate Reflectance if wr is taken
    override func additionalCalculationOnCurrentSpectrum(){
        if(pageContainer!.reflectanceWhiteReference != nil){
            currentSpectrum = SpectrumCalculator.calculateReflectance(currentSpectrum: self.currentSpectrum!, whiteReferenceSpectrum: self.pageContainer!.reflectanceWhiteReference!)
        }
    }
    
}
