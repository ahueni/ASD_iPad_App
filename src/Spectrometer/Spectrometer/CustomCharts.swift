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
    
    let xAxisLabel = UILabel()
    let yAxisLabel = UILabel()
    
    override init(frame : CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let font: UIFont = UIFont.defaultFontRegular(size: 12.0)
        let fontBold: UIFont = UIFont.defaultFontBold(size: 12)
        
        noDataFont = font
        noDataText = "There is no data to display. Please select an action to perform an aquire routine.";
        
        borderColor = UIColor.lightGray
        
        self.setExtraOffsets(left: 20, top: 20, right: 30, bottom: 30)
        
        xAxis.axisLineWidth = 1
        xAxis.labelFont = font
        xAxis.drawLabelsEnabled = true
        
        xAxis.enabled = true
        
        xAxis.gridColor = borderColor
        xAxis.axisLineColor = borderColor
        drawBordersEnabled = true
        
        xAxis.labelPosition = XAxis.LabelPosition.bottom
        
        leftAxis.drawLabelsEnabled = false
        
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
        
        //set axis description labels
        yAxisLabel.text = "DN"
        yAxisLabel.font = fontBold
        // rotate 90 degrees
        yAxisLabel.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi / 2)
        yAxisLabel.textAlignment = NSTextAlignment.center
        addSubview(yAxisLabel)
        
        xAxisLabel.font = fontBold
        xAxisLabel.text = "Wavelength [nm]"
        xAxisLabel.textAlignment = NSTextAlignment.center
        addSubview(xAxisLabel)
    }
    
    override func layoutSubviews() {
        xAxisLabel.frame =  CGRect(x: 0, y: frame.height-30, width: frame.width, height: 30)
        yAxisLabel.frame = CGRect(x: frame.width-30, y: 0, width: 30, height: frame.height)
    }
    
    func setAxisValues(mode : MeasurementMode) -> Void {
        switch mode {
        case .Raw:
            yAxisLabel.text = "DN"
        case .Radiance:
            yAxisLabel.text = "Radiance [Wm⁻²sr⁻¹nm⁻¹]"
        case .Reflectance:
            yAxisLabel.text = "Reflectance Factor"
        }
        
        self.rightAxis.axisMinimum = 0
        self.rightAxis.axisMaximum = mode.rawValue
        self.leftAxis.axisMinimum = 0
        self.leftAxis.axisMaximum = mode.rawValue
    }
}

class SpectrumLineChartDataSet: LineChartDataSet {
    
    init(values: [ChartDataEntry]?, color: UIColor, lineWidth: CGFloat) {
        super.init(values: values, label: "")
        
        valueFont = UIFont.defaultFontRegular(size: 14.0)
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
