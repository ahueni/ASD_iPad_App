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

class RadianceWhiteRefrenceViewController : BaseMeasurementModal{
    
    var aquireLoopOn = false // Indicates if a aquireLoop is running
    var whiteRefrences = [FullRangeInterpolatedSpectrum]()
    var currentWhiteRefrence : FullRangeInterpolatedSpectrum? = nil
    
    @IBOutlet var progressBar: CustomProgressBar!
    @IBOutlet weak var startWhiteRefrenceButton: LoadingButton!
    @IBOutlet weak var nextButton: UIBlueButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aquireLoopOn = true
        DispatchQueue.global().async {
            while(self.aquireLoopOn){
                self.aquire()
            }
        }
        
        progressBar.initialize(total: 3)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        aquireLoopOn = false
    }
    
    func aquire() {
        // Background tasks
        currentWhiteRefrence = CommandManager.sharedInstance.aquire(samples: (self.appDelegate.config?.sampleCount)!)
        
        DispatchQueue.main.async {
            //update ui
            self.updateLineChart2()
        }
    }
    
    @IBAction func takeWhiteRefrence(_ sender: UIButton) {
        startWhiteRefrenceButton.showLoading()
        nextButton.isEnabled = false
        
        let whiteRefrencePage = pageContainer!.currentPage as! WhiteReferencePage
        
        DispatchQueue.global().async {
            for i in 0...whiteRefrencePage.whiteReferenceCount-1
            {
                self.updateProgressBar(measurmentCount: i+1, statusText: "Bereite nächste Messung vor", totalMeasurments : whiteRefrencePage.whiteReferenceCount)
                sleep(UInt32(whiteRefrencePage.whiteReferenceDelay)) // Wait two second before starting the next measurment
                self.updateProgressBar(measurmentCount: i+1, statusText: "Messe...", totalMeasurments : whiteRefrencePage.whiteReferenceCount)
                let spectrum = CommandManager.sharedInstance.aquire(samples: self.appDelegate.config!.sampleCount)
                self.whiteRefrences.append(spectrum)
                switch whiteRefrencePage.whiteRefrenceEnum
                {
                case .Before:
                    self.pageContainer!.whiteRefrenceBeforeSpectrumList.append(spectrum)
                    break
                case .After:
                    self.pageContainer!.whiteRefrenceAfterSpectrumList.append(spectrum)
                    break
                }
                self.updateLineChart2()
                self.updateProgressBar(measurmentCount: i+1, statusText: "Messung beendet", totalMeasurments : whiteRefrencePage.whiteReferenceCount)
                sleep(UInt32(whiteRefrencePage.whiteReferenceDelay)) //Wait two second
            }
            DispatchQueue.main.async {
                
                self.startWhiteRefrenceButton.hideLoading()
                self.startWhiteRefrenceButton.setTitle("Retake white Refrence", for: .normal)
                self.nextButton.isEnabled = true
            }
        }
        
        
    }
    
    
    func updateProgressBar(measurmentCount:Int, statusText:String, totalMeasurments : Int)
    {
        DispatchQueue.main.async {
            self.progressBar.updateProgressBar(actual: measurmentCount, statusText: statusText)
        }
    }
    
    func updateLineChart2(){
        
        var spectrums = whiteRefrences
        spectrums.insert(currentWhiteRefrence!, at: 0)
        
        self.MeasurementLineChart.setAxisValues(min: 0, max: 65000)
        var dataSets = [ChartDataSet]()
        
        for j in 0...spectrums.count-1{
            
            var storedValues: [ChartDataEntry] = []
            var spectrum = spectrums[j]
            for i in 0...(currentWhiteRefrence!.spectrumBuffer.count)-1 {
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
    
}
