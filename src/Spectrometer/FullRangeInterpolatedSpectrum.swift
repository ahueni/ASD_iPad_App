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
    
    static let SIZE: Int = 11904
    
    var spectrumHeader: SpectrumHeader
    var spectrumBuffer: [Float]
    
    init(spectrumHeader: SpectrumHeader, spectrumBuffer: [Float]) {
        self.spectrumHeader = spectrumHeader
        self.spectrumBuffer = spectrumBuffer
    }
    
    func subtractDarkCurrent(darkCurrentBuffer: [Float]) -> Void {
        
        /*
        spectrumHeader.vHeader.darkSubtracted = DarkSubtracted.Yes
        spectrumHeader.s1Header.darkSubtracted = DarkSubtracted.Yes
        spectrumHeader.s2Header.darkSubtracted = DarkSubtracted.Yes
        
        for (i, dVal) in darkCurrentBuffer.enumerated() {
            let sVal = spectrumBuffer[i]
            let calculated = sVal - dVal
            spectrumBuffer[i] = calculated
        }
        */
        
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
