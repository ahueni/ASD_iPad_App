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

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

extension Array where Element : FloatingPoint {
    
    func getChartData(lineColor: UIColor = UIColor.black) -> LineChartDataSet {
        
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
        
        return SpectrumLineChartDataSet(values: values, label: "", color: lineColor, drawCircles: false)
        
    }}
 
