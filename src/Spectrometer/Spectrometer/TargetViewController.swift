//
//  FastMeasurmentViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 22.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class TargetViewController : MeasurementAquireBase
{
    override func viewDidLoad() {
        super.viewDidLoad()
        let targetPage = aquireMeasurmentPage as! TargetPage
        self.takeDarkCurrent = targetPage.takeDarkCurrent
    }
    
    override func finishedMeasurement() {
        super.finishedMeasurement()
        DispatchQueue.main.async {
            self.lineChartDataContainer.lineChartPool.removeAll()
        }
    }
    
    override func handleRawSpectrum(currentSpectrum: FullRangeInterpolatedSpectrum) {
        
        switch self.pageContainer.measurmentMode! {
        case .Raw:
            self.writeRawFileAsync(spectrum: currentSpectrum, dataType: .RawType)
        case MeasurementMode.Reflectance:
            self.writeReflectanceFileAsync(spectrum: currentSpectrum, whiteRefrenceSpectrum: InstrumentStore.sharedInstance.whiteReferenceSpectrum!, dataType: .RefType)
        case MeasurementMode.Radiance:
            self.writeRadianceFilesAsync(spectrums: [currentSpectrum], dataType: .RadType, isWhiteReference: false)
        }
    }
    
    override func viewCalculationsOnCurrentSpectrum(currentSpectrum: FullRangeInterpolatedSpectrum) -> [Float] {
        if(self.pageContainer.measurmentMode == MeasurementMode.Radiance)
        {
            chartDisplayMode = .Radiance
            return SpectrumCalculatorService.calculateRadiance(spectrum: currentSpectrum)
        }
        chartDisplayMode = .Raw
        return currentSpectrum.spectrumBuffer
    }
    
    override func handleChartData(chartData: [Float]) {
        lineChartDataContainer.lineChartPool.removeAll()
        lineChartDataContainer.lineChartPool.append(chartData.getChartData(lineColor: UIColor.blue, lineWidth: 1))
    }
    
}
