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
    
    @IBOutlet weak var startWhiteRefrenceButton: LoadingButton!
    @IBOutlet var MeasureProgressBar: MeasurementProgressBar!
    @IBOutlet weak var nextButton: UIBlueButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aquireLoopOn = true
        DispatchQueue.global().async {
            while(self.aquireLoopOn){
                self.aquire()
            }
        }
        
        MeasureProgressBar.initialize(total: 3)
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
        
        DispatchQueue.global().async {
            for i in 0...2
            {
                //self.updateProgressBar(measurmentCount: i+1, statusText: "Bereite nächste Messung vor")
                //sleep(1 // Wait two second before starting the next measurment
                self.updateProgressBar(measurmentCount: i+1, statusText: "Messe...")
                let spectrum = CommandManager.sharedInstance.aquire(samples: self.appDelegate.config!.sampleCount)
                self.whiteRefrences.append(spectrum)
                self.updateLineChart2()
                //self.updateProgressBar(measurmentCount: i+1, statusText: "Messung beendet")
                //sleep(2) //Wait two second
            }
            DispatchQueue.main.async {
                
                self.startWhiteRefrenceButton.hideLoading()
                self.startWhiteRefrenceButton.setTitle("Retake white Refrence", for: .normal)
                self.nextButton.isEnabled = true
            }
        }
        
        
    }
    
    
    func updateProgressBar(measurmentCount:Int, statusText:String)
    {
        /*
        DispatchQueue.main.async {
            self.MeasureProgressBar.updateProgressBar(actual: measurmentCount, total: (self.pageContainer!.measurmentSettings?.measurementCount)!, statusText: statusText)
        }
 */
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
