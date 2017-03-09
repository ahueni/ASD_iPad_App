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

class RadianceWhiteRefrenceViewController : MeasurementAquireBase {
    
    var whiteRefrences : [FullRangeInterpolatedSpectrum] = [] // temporary store for taken white refrences as raw data
    
    //override to remove all stored whiteReferences. Then do normal routine with a super call
    override func startMesurement() {
        super.startMesurement()
        whiteRefrences.removeAll()
    }
    
    // only show calculations
    override func additionalCalculationOnCurrentSpectrum(currentSpectrum: FullRangeInterpolatedSpectrum) -> [Float]{
        return SpectrumCalculator.calculateRadiance(spectrum: currentSpectrum)
    }
    
    override func handleRawSpectrum(currentSpectrum: FullRangeInterpolatedSpectrum) {
        whiteRefrences.append(currentSpectrum)
    }
    
    override func handleChartData(chartData: [Float]) {
        lineChartDataContainer.lineChartPool.append(chartData.getChartData(lineColor: UIColor.randomColor(), lineWidth: 1))
    }
    
    override func goToNextPage() {
        writeRadianceFilesAsync(spectrums: whiteRefrences, dataType: .RadType, isWhiteReference: true)
        super.goToNextPage()
    }
    
}
