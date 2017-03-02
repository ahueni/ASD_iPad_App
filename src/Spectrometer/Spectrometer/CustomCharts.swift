//
//  CustomCharts.swift
//  Spectrometer
//
//  Created by raphi on 20.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation
import Charts

class SpectrumLineChartView : LineChartView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let font: UIFont = UIFont(name: "Open Sans", size: 12)!
        
        noDataFont = font
        noDataText = "There is no data to display. Please select an action to perform an aquire routine.";
        
        borderColor = UIColor.lightGray
        
        self.setExtraOffsets(left: 20, top: 20, right: 20, bottom: 20)
        
        xAxis.axisLineWidth = 1
        xAxis.labelPosition = XAxis.LabelPosition.bothSided
        
        xAxis.labelFont = font
        xAxis.drawLabelsEnabled = true
        
        xAxis.enabled = true
        
        xAxis.gridColor = borderColor
        xAxis.axisLineColor = borderColor
        
        leftAxis.spaceBottom = 0
        rightAxis.spaceBottom = 0
        
        leftAxis.spaceTop = 0
        rightAxis.spaceTop = 0
        
        leftAxis.axisLineWidth = 1
        rightAxis.axisLineWidth = 1
        
        leftAxis.gridColor = borderColor
        rightAxis.gridColor = borderColor
        
        leftAxis.axisLineColor = borderColor
        rightAxis.axisLineColor = borderColor
        
        
        rightAxis.labelFont = font
        leftAxis.labelFont = font
        
        legend.enabled = false
        legend.drawInside = false
        
        chartDescription?.enabled = false
        
    }
    
    func setAxisValues(min: Double, max: Double) -> Void {
        self.rightAxis.axisMinimum = min
        self.rightAxis.axisMaximum = max
        self.leftAxis.axisMinimum = min
        self.leftAxis.axisMaximum = max
    }
    
}

class SpectrumLineChartDataSet: LineChartDataSet {
    
    let openSansFont = UIFont(name: "Open Sans", size: 14)!
    
    init(values: [ChartDataEntry]?, color: UIColor, lineWidth: CGFloat) {
        super.init(values: values, label: "")
        
        valueFont = openSansFont
        drawCirclesEnabled = false
        self.lineWidth = lineWidth
        lineCapType = CGLineCap.round
        colors = [color]
        drawValuesEnabled = false
        
    }
    
    required init() {
        super.init()
    }
    
}
