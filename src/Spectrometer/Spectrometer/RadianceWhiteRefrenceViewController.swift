//
//  RadianceWhiteRefrenceViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 13.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit
import Charts

class RadianceWhiteRefrenceViewController : BaseWhiteReferenceViewController{
    
    var whiteRefrences = [FullRangeInterpolatedSpectrum]() // temporary store for taken white refrences
    
    //override to remove all stored whiteReferences. Then do normal routine with a super call
    override func takeWhiteRefrence(_ sender: UIButton) {
        whiteRefrences.removeAll()
        super.takeWhiteRefrence(sender)
    }
    
    override func updateLineChart(spectrum: FullRangeInterpolatedSpectrum) {
        // copy whiteRefrences to new Array and insert the actual measurment
        var spectrums = whiteRefrences
        spectrums.insert(currentSpectrum!, at: 0)
        
        self.MeasurementLineChart.setAxisValues(min: 0, max: 65000)
        var dataSets = [ChartDataSet]()
        
        for j in 0...spectrums.count-1{
            
            var storedValues: [ChartDataEntry] = []
            var spectrum = spectrums[j]
            for i in 0...(currentSpectrum!.spectrumBuffer.count)-1 {
                var chartEntry = ChartDataEntry(x: Double(i+350), y: Double(spectrum.spectrumBuffer[i]))
                storedValues.append(chartEntry)
            }
            
            let lineChartDataSet = SpectrumLineChartDataSet(values: storedValues, label: "abc")
            if(j == 0){
                lineChartDataSet.setColor(.black)
            }
            else
            {
                lineChartDataSet.setColor(.blue)
            }
            dataSets.append(lineChartDataSet)
        }
        
        for dataSet in dataSets{
            print("color: " + dataSet.color(atIndex: 1).description)
        }
        
        let lineChartData =  LineChartData(dataSets: dataSets)
        
        DispatchQueue.main.async {
            self.MeasurementLineChart.data = lineChartData
        }
        
    }
    
    override func setSpectrum(){
        self.whiteRefrences.append(CommandManager.sharedInstance.aquire(samples: self.appDelegate.config!.sampleCount))
    }
    
    override func goToNextPage() {
        // add all whiteRefrences to the parent VC
        switch self.whiteRefrencePage.whiteRefrenceEnum
        {
        case .Before:
            self.pageContainer.whiteRefrenceBeforeSpectrumList.append(contentsOf: whiteRefrences)
            break
        case .After:
            self.pageContainer.whiteRefrenceAfterSpectrumList.append(contentsOf: whiteRefrences)
            break
        }
        
        super.goToNextPage()
    }
    
}
