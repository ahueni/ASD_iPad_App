//
//  FullRangeInterpolatedSpectrum.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation
import Charts

class FullRangeInterpolatedSpectrum : BaseSpectrum {
    
    static let SIZE: Int = 8860
    
    var spectrumHeader: SpectrumHeader
    var spectrumBuffer: [Float]
    
    init(spectrumHeader: SpectrumHeader, spectrumBuffer: [Float]) {
        self.spectrumHeader = spectrumHeader
        self.spectrumBuffer = spectrumBuffer
    }
    
    func subtractDarkCurrent(darkCurrent: FullRangeInterpolatedSpectrum, darkCorrectionRange: Int, drift: Float) -> Void {
        
        spectrumHeader.vinirHeader.darkSubtracted = DarkSubtracted.Yes
        spectrumHeader.swir1Header.darkSubtracted = DarkSubtracted.Yes
        spectrumHeader.swir2Header.darkSubtracted = DarkSubtracted.Yes
        
        for i in 0...darkCorrectionRange{
            spectrumBuffer[i] = spectrumBuffer[i] - darkCurrent.spectrumBuffer[i] + drift;
        }
        
        /*
        for (i, dVal) in darkCurrent.spectrumBuffer.enumerated() {
            let sVal = spectrumBuffer[i]
            let calculated = sVal - dVal + drift
            spectrumBuffer[i] = calculated
        }*/
        
        
    }
    
    func getChartData() -> LineChartData {
        var values: [ChartDataEntry] = []
        for i in 0...self.spectrumBuffer.count-1 {
            //print(spectrumBuffer[i])
            values.append(ChartDataEntry(x: Double(i+350), y: Double(spectrumBuffer[i])))
        }
        let lineChartDataSet = SpectrumLineChartDataSet(values: values, label: "-")
        return LineChartData(dataSet: lineChartDataSet)
    }
    
}
