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
    var count = 10
    
    @IBOutlet weak var MesureCountLabel: UILabel!
    @IBOutlet weak var CountDownLabel: UILabel!
    var whiteRefrenceSpectrum :FullRangeInterpolatedSpectrum? = nil
    
    @IBAction func StartMeasurmentsButtonClicked(_ sender: UIButton) {
        startMeasureLoop()
    }
    
    func startMeasureLoop()
    {
        DispatchQueue(label: "test").async {
            for i in 0...(self.pageContainer!.measurmentSettings!.measurementCount)-1
            {
                self.updateStateLabel(state: "Bereite nächste Messung vor")
                sleep(2) //Wait two second before starting the next measurment
                self.updateMesurmentLabels(measurmentCount: i+1)
                self.updateStateLabel(state: "Messe...")
                let spectrum = CommandManager.sharedInstance.aquire(samples: self.appDelegate.config!.sampleCount)
                self.pageContainer!.spectrumDataList.append(SpectrumData(spectrum: spectrum))
                self.updateLineChart(spectrum: spectrum)
                self.updateStateLabel(state: "Messung beendet")
                sleep(2) //Wait two second
            }
        }
    }
    
    func updateMesurmentLabels(measurmentCount :Int)
    {
        DispatchQueue.main.async {
            //update ui
            self.MesureCountLabel.text = "Messung " + measurmentCount.description
        }
    }
    
    func updateStateLabel(state : String){
        DispatchQueue.main.async {
            //update ui
            self.CountDownLabel.text = state
        }
    }
    
}
