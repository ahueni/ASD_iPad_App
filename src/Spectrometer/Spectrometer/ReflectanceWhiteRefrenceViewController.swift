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

class ReflectanceWhiteRefrenceViewController : MeasurementAquireBase {
    
    override func handleRawSpectrum(currentSpectrum: FullRangeInterpolatedSpectrum) {
        self.pageContainer!.reflectanceWhiteReference = currentSpectrum
    }
    
    // only show calculations
    override func additionalCalculationOnCurrentSpectrum(currentSpectrum: FullRangeInterpolatedSpectrum) -> [Float] {
        if let whiteReference = pageContainer.reflectanceWhiteReference {
            return SpectrumCalculator.calculateReflectance(spectrumBuffer: currentSpectrum.spectrumBuffer, whiteReferenceBuffer: whiteReference.spectrumBuffer)
        }
        return currentSpectrum.spectrumBuffer
    }
    
    override func handleChartData(chartData: [Float]) {
        lineChartDataContainer.lineChartPool.removeAll()
        lineChartDataContainer.lineChartPool.append(chartData.getChartData(lineColor: UIColor.blue, lineWidth: 1))
    }
    
}
