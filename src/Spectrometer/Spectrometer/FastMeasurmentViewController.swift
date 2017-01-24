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
    var whiteRefrenceSpectrum :FullRangeInterpolatedSpectrum? = nil
    
    override func viewDidLoad() {
        let whiteRefrence = UIAlertController(title: "WhiteRefrence", message: "Es wird ein WhiteRefrence gestartet.", preferredStyle: .alert)
        whiteRefrence.addAction(UIAlertAction(title: "OK", style: .cancel, handler: whiteRefrenceHandler))
        self.present(whiteRefrence, animated: true, completion: nil)
        
    }
    
    func whiteRefrenceHandler(action : UIAlertAction){
        let spectrum = CommandManager.sharedInstance.aquire(samples: 10)
        whiteRefrenceSpectrum = spectrum
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
                self.updateStateLabel(state: "Messe...")
                let spectrum = CommandManager.sharedInstance.aquire(samples: 10)
                self.pageContainer?.spectrums.append((self.whiteRefrenceSpectrum!, spectrum))
                self.updateLineChart(spectrum: spectrum)
                self.updateStateLabel(state: "Messung beendet")
                sleep(2) //Wait two second
                self.updateStateLabel(state: "Bereite nächste Messung vor")
                sleep(2) //Wait two second before starting the next measurment
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
    
    func updateLineChart(spectrum : FullRangeInterpolatedSpectrum){
        DispatchQueue.main.async {
            //update ui
            self.MeasurementLineChart.setAxisValues(min: 0, max: 65000)
            self.MeasurementLineChart.data = spectrum.getChartData()
        }
    }
    
    override func goToNextPage() {
        pageContainer?.goToNextPage()
    }
    
}
