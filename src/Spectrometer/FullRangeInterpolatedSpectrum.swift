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
            //print(spectrumBuffer[i])
            values.append(ChartDataEntry(x: Double(i+350), y: Double(spectrumBuffer[i])))
        }
        let lineChartDataSet = SpectrumLineChartDataSet(values: values, label: "-")
        return LineChartData(dataSet: lineChartDataSet)
    }
    
}
