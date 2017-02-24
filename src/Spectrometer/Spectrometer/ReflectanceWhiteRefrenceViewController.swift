//
//  WhiteRefrenceViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 30.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit
import Charts

class ReflectanceWhiteRefrenceViewController : BaseWhiteReferenceViewController {
    
    var currentWhiteRefrence : FullRangeInterpolatedSpectrum? = nil
    
    override func setSpectrum(){
        self.currentWhiteRefrence = CommandManager.sharedInstance.aquire(samples: self.appDelegate.config!.sampleCount)
    }
    
    override func updateLineChart(spectrum: FullRangeInterpolatedSpectrum) {
        // Show the LineChart if no whiteRefrence was taken. Show the reflectance otherwise
        currentWhiteRefrence == nil ? super.updateLineChart(spectrum: currentSpectrum!) : self.showReflectance()
    }
    
    override func goToNextPage() {
        // Add the white Refrence to the parent VC
        pageContainer!.whiteRefrenceBeforeSpectrumList.append(currentWhiteRefrence!)
        super.goToNextPage()
    }
    
    // Show Reflectance => WhiteRefrence / Current spectrum
    func showReflectance() {
        DispatchQueue.main.async {
            //update ui
            self.MeasurementLineChart.setAxisValues(min: 0, max: 5)
            
            var values: [ChartDataEntry] = []
            for i in 0...self.currentWhiteRefrence!.spectrumBuffer.count-1 {
                if(i == 1201)
                {
                    print((self.currentWhiteRefrence?.spectrumBuffer[i].description)! + " / " + self.currentSpectrum!.spectrumBuffer[i].description)
                    print("result: " + ((self.currentWhiteRefrence?.spectrumBuffer[i])! / self.currentSpectrum!.spectrumBuffer[i]).description)
                }
                values.append(ChartDataEntry(x: Double(i+350), y: Double(self.currentSpectrum!.spectrumBuffer[i] /  self.currentWhiteRefrence!.spectrumBuffer[i] )))
            }
            let lineChartDataSet = SpectrumLineChartDataSet(values: values, label: "-")
            let lineChartData =  LineChartData(dataSet: lineChartDataSet)
            DispatchQueue.main.async {
                self.MeasurementLineChart.data = lineChartData
            }
        }
    }
    
}
