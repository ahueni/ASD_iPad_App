//
//  Extensions.swift
//  Spectrometer
//
//  Created by raphi on 19.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation
import Charts

extension FloatingPoint {
    
    init?(_ bytes: [UInt8]) {
        guard bytes.count == MemoryLayout<Self>.size else { return nil }
        self = bytes.withUnsafeBytes {
            return $0.load(fromByteOffset: 0, as: Self.self)
        }
    }
}


extension Array where Element : FloatingPoint {
    func getChartData() -> LineChartData {
        var values: [ChartDataEntry] = []
        let startingWaveLength = InstrumentSettingsCache.sharedInstance.startingWaveLength!
        
        for i in 0...self.count-1 {
            
            // read starting wavelength and count it to actual index of x-chart entry
            if let value = self[i] as? Float {
                let chartEntry = ChartDataEntry(x: Double(i + startingWaveLength), y: Double(value))
                values.append(chartEntry)
            }
            
            if let value = self[i] as? Double {
                let chartEntry = ChartDataEntry(x: Double(i + startingWaveLength), y: value)
                values.append(chartEntry)
            }
        }
        let lineChartDataSet = SpectrumLineChartDataSet(values: values, label: nil)
        return LineChartData(dataSet: lineChartDataSet)
        
    }}
 
