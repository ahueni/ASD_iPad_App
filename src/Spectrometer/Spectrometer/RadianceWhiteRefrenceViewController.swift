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

class RadianceWhiteRefrenceViewController : BaseWhiteReferenceViewController {
    
    var whiteRefrences = [FullRangeInterpolatedSpectrum]() // temporary store for taken white refrences as raw data
    var whiteRefrencesInRadiance = [FullRangeInterpolatedSpectrum]() // temporary store for taken white refrences
    
    //override to remove all stored whiteReferences. Then do normal routine with a super call
    override func takeWhiteRefrence(_ sender: UIButton) {
        whiteRefrences.removeAll()
        whiteRefrencesInRadiance.removeAll()
        super.takeWhiteRefrence(sender)
    }
    
    override func updateLineChart(spectrum: FullRangeInterpolatedSpectrum) {
        // copy whiteRefrences to new Array and insert the actual measurment
        var spectrums = whiteRefrencesInRadiance
        currentSpectrum!.spectrumBuffer = SpectrumCalculator.calculateRadiance(spectrum: currentSpectrum!)
        spectrums.insert(currentSpectrum!, at: 0)
        
        self.MeasurementLineChart.setAxisValues(min: 0, max: 65000)
        var dataSets = [ChartDataSet]()
        
        for j in 0...spectrums.count-1{
            if(InstrumentSettingsCache.sharedInstance.cancelMeasurment){
                return
            }
            
            var storedValues: [ChartDataEntry] = []
            let spectrum = spectrums[j]
            
            for i in 0..<currentSpectrum!.spectrumBuffer.count {
                let chartEntry = ChartDataEntry(x: Double(i+350), y: Double(spectrum.spectrumBuffer[i]))
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
        
        /*
        for dataSet in dataSets{
            print("color: " + dataSet.color(atIndex: 1).description)
        }
 */
        
        let lineChartData =  LineChartData(dataSets: dataSets)
        
        DispatchQueue.main.async {
            self.MeasurementLineChart.setAxisValues(min: 0, max: 1.6)
            self.MeasurementLineChart.data = lineChartData
        }
    }
    
    override func setSpectrum(){
        //Aquire spectrum
        let sampleCount = InstrumentSettingsCache.sharedInstance.instrumentConfiguration.sampleCount
        let spectrum = CommandManager.sharedInstance.aquire(samples: sampleCount)
        // Calculate Radiance values
        let radianceSpectrum = SpectrumCalculator.calculateRadiance(spectrum: spectrum)
        // add whiteReference to the whiteReferenceLists
        self.whiteRefrences.append(spectrum)
        //self.whiteRefrencesInRadiance.append(radianceSpectrum)
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
        
        writeFileAsync(spectrums: whiteRefrences, isWhiteReference: true, dataType: DataType.RadType)
        
        super.goToNextPage()
    }
    
}
