//
//  RadianceWhiteRefrenceViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 13.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit
import Charts

class RadianceWhiteRefrenceViewController : BaseWhiteReferenceViewController {
    
    var whiteRefrences : [FullRangeInterpolatedSpectrum] = [] // temporary store for taken white refrences as raw data
    
    //override to remove all stored whiteReferences. Then do normal routine with a super call
    override func takeWhiteRefrence(_ sender: UIButton) {
        whiteRefrences.removeAll()
        lineChartDataContainer.lineChartPool.removeAll()
        super.takeWhiteRefrence(sender)
    }
    
    // only show calculations
    override func additionalCalculationOnCurrentSpectrum(){
        currentSpectrum!.spectrumBuffer = SpectrumCalculator.calculateRadiance(spectrum: currentSpectrum!)
    }
    
    // set spectrum and calculate
    override func setSpectrum(whiteReferenceSpectrum : FullRangeInterpolatedSpectrum){
        // Calculate Radiance values
        let radianceSpectrumBuffer = SpectrumCalculator.calculateRadiance(spectrum: whiteReferenceSpectrum)
        // add whiteReference to the whiteReferenceLists
        self.whiteRefrences.append(whiteReferenceSpectrum)
        
        
        let chartData = radianceSpectrumBuffer.getChartData(lineColor: UIColor.randomColor(), lineWidth: 1)
        lineChartDataContainer.lineChartPool.append(chartData)
    }
    
    override func goToNextPage() {
        writeRadianceFilesAsync(spectrums: whiteRefrences, dataType: .RadType, isWhiteReference: true)
        super.goToNextPage()
    }
    
}
