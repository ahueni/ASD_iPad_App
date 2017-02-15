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
        /*
        startMeasurementButton.showLoading()
        
        DispatchQueue.global().async {
            for i in 0...(self.pageContainer!.measurmentSettings!.measurementCount)-1
            {
                //self.updateProgressBar(measurmentCount: i+1, statusText: "Bereite nächste Messung vor")
                //sleep(1 // Wait two second before starting the next measurment
                self.updateProgressBar(measurmentCount: i+1, statusText: "Messe...")
                let spectrum = CommandManager.sharedInstance.aquire(samples: self.appDelegate.config!.sampleCount)
                self.pageContainer!.spectrumDataList.append(SpectrumData(spectrum: spectrum))
                self.updateLineChart(spectrum: spectrum)
                //self.updateProgressBar(measurmentCount: i+1, statusText: "Messung beendet")
                //sleep(2) //Wait two second
            }
            self.finishMeasurement()
        }
 */
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
    
    func updateProgressBar(measurmentCount:Int, statusText:String)
    {
        /*
        DispatchQueue.main.async {
            self.MeasureProgressBar.updateProgressBar(actual: measurmentCount, total: (self.pageContainer!.measurmentSettings?.measurementCount)!, statusText: statusText)
        }
 */
    }
    
}
