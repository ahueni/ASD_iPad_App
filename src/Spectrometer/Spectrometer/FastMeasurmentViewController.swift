//
//  FastMeasurmentViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 22.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class FastMeasurmentViewController : TestSeriesViewController
{
    var timer :Timer? = nil
    var count = 10
    var measurementsDone = 0
    
    @IBOutlet weak var MesureCountLabel: UILabel!
    @IBOutlet weak var CountDownLabel: UILabel!
    @IBOutlet weak var MeasurementLineChart: SpectrumLineChartView!
    
    override func viewDidLoad() {
        let whiteRefrence = UIAlertController(title: "WhiteRefrence", message: "Es wird ein WhiteRefrence gestartet.", preferredStyle: .alert)
        whiteRefrence.addAction(UIAlertAction(title: "OK", style: .cancel, handler: whiteRefrenceHandler))
        self.present(whiteRefrence, animated: true, completion: nil)
        
    }
    
    func whiteRefrenceHandler(action : UIAlertAction){
        let spectrum = CommandManager.sharedInstance.aquire(samples: 10)
        updateLineChart(spectrum: spectrum)
        
        let measureAlert = UIAlertController(title: "Messreihe", message: "Eine Messreihe startet.", preferredStyle: .alert)
        measureAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: startMeasureLoop))
        self.present(measureAlert, animated: true, completion: nil)
    }
    
    func startMeasureLoop(action : UIAlertAction)
    {
        DispatchQueue(label: "test").async {
            for i in 0...(self.pageContainer?.measurmentSettings.measurementCount)!-1
            {
                self.updateMesurmentLabels(measurmentCount: i+1)
                let spectrum = CommandManager.sharedInstance.aquire(samples: 10)
                self.updateLineChart(spectrum: spectrum)
                sleep(3) //Wait one second before starting the next measurment
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
    
    func updateLineChart(spectrum : FullRangeInterpolatedSpectrum){
        DispatchQueue.main.async {
            //update ui
            self.MeasurementLineChart.setAxisValues(min: 0, max: 65000)
            self.MeasurementLineChart.data = spectrum.getChartData()
        }
    }
    
}
