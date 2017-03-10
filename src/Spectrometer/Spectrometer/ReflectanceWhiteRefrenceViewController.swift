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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // activate next when white reference already taken
        nextButton.isEnabled = InstrumentStore.sharedInstance.whiteReferenceSpectrum != nil
    }
    
    override func finishedMeasurement() {
        super.finishedMeasurement()
        DispatchQueue.main.async {
            self.startMeasurement.isEnabled = true
            self.startMeasurement.setTitle("Retake White Reference", for: .normal)
        }
    }
    
    override func handleRawSpectrum(currentSpectrum: FullRangeInterpolatedSpectrum) {
        InstrumentStore.sharedInstance.whiteReferenceSpectrum = currentSpectrum
        ViewStore.sharedInstance.restartWhiteReferenceTimer()
    }
    
    override func viewCalculationsOnCurrentSpectrum(currentSpectrum: FullRangeInterpolatedSpectrum) -> [Float] {
        if let whiteReference = InstrumentStore.sharedInstance.whiteReferenceSpectrum {
            chartDisplayMode = .Reflectance
            return SpectrumCalculator.calculateReflectance(spectrumBuffer: currentSpectrum.spectrumBuffer, whiteReferenceBuffer: whiteReference.spectrumBuffer)
        }
        chartDisplayMode = .Raw
        return currentSpectrum.spectrumBuffer
    }
    
    override func handleChartData(chartData: [Float]) {
        lineChartDataContainer.lineChartPool.removeAll()
        lineChartDataContainer.lineChartPool.append(chartData.getChartData(lineColor: UIColor.blue.withAlphaComponent(0.5), lineWidth: 1))
    }
    
}
