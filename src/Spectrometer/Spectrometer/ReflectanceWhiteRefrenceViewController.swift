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

class ReflectanceWhiteRefrenceViewController : BaseMeasurementModal {
    
    @IBOutlet var whiteReferenceButton: LoadingButton!
    @IBOutlet var nextButton: UIBlueButton!
    var currentWhiteRefrence : FullRangeInterpolatedSpectrum? = nil
    
    var aquireLoopOn = false // Indicates if a aquireLoop is running
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aquireLoopOn = true
        DispatchQueue.global().async {
            while(self.aquireLoopOn){
                self.aquire()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        aquireLoopOn = false
    }
    
    func aquire() {
        // Background tasks
        let spectrum = CommandManager.sharedInstance.aquire(samples: (self.appDelegate.config?.sampleCount)!)
        
        DispatchQueue.main.async {
            //update ui
            self.updateValues(whiteReference: spectrum)
        }
    }
    
    @IBAction func TakeWhiteRefrenceButtonClicked(_ sender: UIButton) {
        
        // switch to background thread for aquire white reference
        DispatchQueue.global().async {
            self.currentWhiteRefrence = CommandManager.sharedInstance.aquire(samples: self.appDelegate.config!.sampleCountWhiteRefrence)
        }
    }
    
    func updateValues(whiteReference: FullRangeInterpolatedSpectrum) -> Void {
        
        if(currentWhiteRefrence == nil)
        {
            // switch back to UI Thread for updates
            DispatchQueue.main.async {
                self.updateLineChart(spectrum: whiteReference)
                
                self.nextButton.isEnabled = true
                //self.whiteReferenceButton.hideLoading()
            }
        }
        else
        {
            updateLineChart2(spectrum: whiteReference)
        }
        
    }
    
    override func goToNextPage() {
        pageContainer!.whiteRefrenceBeforeSpectrumList.append(currentWhiteRefrence!)
        super.goToNextPage()
    }
    
    func updateLineChart2(spectrum : FullRangeInterpolatedSpectrum){
        
        DispatchQueue.main.async {
            //update ui
            self.MeasurementLineChart.setAxisValues(min: 0, max: 5)
            
            var values: [ChartDataEntry] = []
            for i in 0...self.currentWhiteRefrence!.spectrumBuffer.count-1 {
                if(i == 1201)
                {
                    print((self.currentWhiteRefrence?.spectrumBuffer[i].description)! + " / " + spectrum.spectrumBuffer[i].description)
                    print("result: " + ((self.currentWhiteRefrence?.spectrumBuffer[i])! / spectrum.spectrumBuffer[i]).description)
                }
                values.append(ChartDataEntry(x: Double(i+350), y: Double(spectrum.spectrumBuffer[i] /  self.currentWhiteRefrence!.spectrumBuffer[i] )))
            }
            let lineChartDataSet = SpectrumLineChartDataSet(values: values, label: "-")
            let lineChartData =  LineChartData(dataSet: lineChartDataSet)
            DispatchQueue.main.async {
                self.MeasurementLineChart.data = lineChartData
            }
        }
    }
    
}
