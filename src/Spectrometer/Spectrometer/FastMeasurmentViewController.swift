//
//  FastMeasurmentViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 22.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class FastMeasurmentViewController : BaseMeasurementModal
{
    var timer :Timer? = nil
    
    @IBOutlet var MeasureProgressBar: MeasurementProgressBar!
    @IBOutlet var startMeasurementButton: LoadingButton!
    @IBOutlet var nextButton: UIBlueButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //MeasureProgressBar.initialize(total: self.pageContainer!.measurmentSettings!.measurementCount)
    }
    
    @IBAction func StartMeasurmentsButtonClicked(_ sender: UIButton) {
        startMeasureLoop()
    }
    
    func startMeasureLoop()
    {
        startMeasurementButton.showLoading()
        let targetPage = pageContainer!.currentPage as! TargetPage
        
        DispatchQueue.global().async {
            for i in 0...targetPage.targetCount-1
            {
                self.updateProgressBar(measurmentCount: i+1, statusText: "Bereite nächste Messung vor", totalCount: targetPage.targetCount)
                sleep(UInt32(targetPage.targetDelay)) // Wait two second before starting the next measurment
                self.updateProgressBar(measurmentCount: i+1, statusText: "Messe...", totalCount: targetPage.targetCount)
                let spectrum = CommandManager.sharedInstance.aquire(samples: self.appDelegate.config!.sampleCount)
                self.pageContainer!.spectrumList.append(spectrum)
                self.updateLineChart(spectrum: spectrum)
                self.updateProgressBar(measurmentCount: i+1, statusText: "Messung beendet", totalCount: targetPage.targetCount)
                sleep(UInt32(targetPage.targetDelay)) //Wait two second
            }
            self.finishMeasurement()
        }
    }
    
    func finishMeasurement() {
        
        DispatchQueue.main.async {
            self.startMeasurementButton.hideLoading()
            self.startMeasurementButton.setTitle("Alle Messungen durchgeführt", for: .application)
            self.startMeasurementButton.isEnabled = false
            self.nextButton.isEnabled = true
            self.goToNextPage()
        }
        
    }
    
    func updateProgressBar(measurmentCount:Int, statusText:String, totalCount : Int)
    {
        DispatchQueue.main.async {
            self.MeasureProgressBar.updateProgressBar(actual: measurmentCount, total: totalCount, statusText: statusText)
        }
    }
    
}
