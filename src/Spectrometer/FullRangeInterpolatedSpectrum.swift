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
    
    func getChartData() -> LineChartData {
        var values: [ChartDataEntry] = []
        for i in 0...self.spectrumBuffer.count-1 {
            // read starting wavelength and count it to actual index of x-chart entry
            let startingWaveLength = InstrumentSettingsCache.sharedInstance.startingWaveLength!
            let chartEntry = ChartDataEntry(x: Double(i + startingWaveLength), y: Double(spectrumBuffer[i]))
            values.append(chartEntry)
        }
        
        let lineChartDataSet = SpectrumLineChartDataSet(values: values, label: nil)
        return LineChartData(dataSet: lineChartDataSet)
    }
    
}
