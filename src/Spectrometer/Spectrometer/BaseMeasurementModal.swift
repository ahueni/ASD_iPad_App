//
//  BaseMeasurementModal.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 27.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit
import Charts

struct LineChartDataContainer{
    var currentLineChart : LineChartDataSet!
    var lineChartPool : [LineChartDataSet] = []
}

class BaseMeasurementModal : UIViewController
{
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pageContainer : ParentViewController!
    var lineChartDataContainer : LineChartDataContainer! = LineChartDataContainer()
    
    @IBOutlet var MeasurementLineChart: SpectrumLineChartView!
    
    func goToNextPage() {
        pageContainer.goToNextPage()
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        goToNextPage()
    }
    
    @IBAction func CancelButtonClicked(_ sender: UIButton) {
        ViewStore.sharedInstance.cancelMeasurment = true
        dismiss(animated: true, completion: nil)
    }
    
    func updateLineChart(){
        DispatchQueue.main.async {
            //update ui
            self.MeasurementLineChart.setAxisValues(min: 0, max: self.pageContainer.measurmentMode.rawValue)
            
            let lineChartDataSets = [self.lineChartDataContainer.currentLineChart] + self.lineChartDataContainer.lineChartPool
            self.MeasurementLineChart.data = LineChartData(dataSets: lineChartDataSets)
        }
    }
    
    func writeRawFileAsync(spectrum : FullRangeInterpolatedSpectrum, dataType: DataType)
    {
        DispatchQueue.global().async {
            FileWriteManager.sharedInstance.addToQueue(spectrums: [spectrum], settings: self.pageContainer!.measurmentSettings, dataType: dataType)
        }
    }
    
    func writeReflectanceFileAsync(spectrum : FullRangeInterpolatedSpectrum, whiteRefrenceSpectrum: FullRangeInterpolatedSpectrum, dataType: DataType)
    {
        DispatchQueue.global().async {
            FileWriteManager.sharedInstance.addToQueue(spectrums: [spectrum], whiteRefrenceSpectrum: whiteRefrenceSpectrum, settings: self.pageContainer!.measurmentSettings, dataType: dataType)
        }
    }
    
    func writeRadianceFilesAsync(spectrums : [FullRangeInterpolatedSpectrum], dataType: DataType, isWhiteReference: Bool){
        DispatchQueue.global().async {
            let base = ViewStore.sharedInstance.instrumentConfiguration.base!
            let lamp = ViewStore.sharedInstance.instrumentConfiguration.lamp!
            let fiberOptic = InstrumentStore.sharedInstance.selectedForeOptic!
            let radianceCalibrationFiles = RadianceCalibrationFiles(baseFile: base, lampFile: lamp, fiberOptic: fiberOptic)
            
            let fileSuffix = isWhiteReference ? "_WR" : ""
            
            DispatchQueue.global().async {
                FileWriteManager.sharedInstance.addToQueue(spectrums: spectrums, settings: self.pageContainer!.measurmentSettings, dataType: dataType, radianceCalibrationFiles: radianceCalibrationFiles, fileSuffix: fileSuffix)
            }
        }
    }
}
