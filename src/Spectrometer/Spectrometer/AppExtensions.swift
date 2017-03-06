//
//  AppExtensions.swift
//  Spectrometer
//
//  Created by raphi on 06.03.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit
import Charts

extension UIColor {
    static func randomColor() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 1.0)
    }
}

extension Array where Element : FloatingPoint {
    func getChartData(lineColor: UIColor = UIColor.black, lineWidth: CGFloat = 2) -> LineChartDataSet {
        
        var values: [ChartDataEntry] = []
        
        // is there a way to have this from file or spectrometer
        let startingWaveLength = 350
        
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
        
        return SpectrumLineChartDataSet(values: values, color: lineColor, lineWidth: lineWidth)
        
    }}
