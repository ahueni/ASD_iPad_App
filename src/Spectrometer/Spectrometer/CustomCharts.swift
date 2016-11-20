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
        
        let font: UIFont = UIFont(name: "Open Sans", size: 14)!
        
        noDataFont = font
        noDataText = "Es wurden noch keine Daten empfanen um im Diagramm dargestellt zu werden";
        
        borderColor = UIColor.black
        
        self.setExtraOffsets(left: 20, top: 20, right: 20, bottom: 20)
        
        xAxis.axisLineWidth = 1
        xAxis.labelPosition = XAxis.LabelPosition.bothSided
        xAxis.labelFont = font
        xAxis.drawLabelsEnabled = true
        xAxis.enabled = true
        
        leftAxis.spaceBottom = 0
        rightAxis.spaceBottom = 0
        
        leftAxis.spaceTop = 0
        rightAxis.spaceTop = 0
        
        rightAxis.axisLineWidth = 1
        
        rightAxis.gridColor = UIColor.black
        
        rightAxis.labelFont = font
        leftAxis.labelFont = font
        
        legend.enabled = false
        
    }
    
}

class SpectrumLineChartDataSet: LineChartDataSet {
    
    let openSansFont = UIFont(name: "Open Sans", size: 14)!
    
    init(values: [ChartDataEntry]?, label: String?, color: UIColor, drawCircles: Bool) {
        super.init(values: values, label: label)
        
        valueFont = openSansFont
        drawCirclesEnabled = drawCircles
        lineWidth = 2
        highlightLineWidth = 1
        lineCapType = CGLineCap.round
        colors = [color]
        
    }
    
    override init(values: [ChartDataEntry]?, label: String?) {
        super.init(values: values, label: label)
        valueFont = openSansFont
        drawCirclesEnabled = false
        lineWidth = 2
        highlightLineWidth = 1
        lineCapType = CGLineCap.round
        colors = [UIColor.black]
        
    }
    
    required init() {
        super.init()
        valueFont = openSansFont
        drawCirclesEnabled = false
        lineWidth = 2
        highlightLineWidth = 1
        lineCapType = CGLineCap.round
        colors = [UIColor.black]
        
    }
    
}
