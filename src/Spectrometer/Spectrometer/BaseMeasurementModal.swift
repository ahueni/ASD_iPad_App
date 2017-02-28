//
//  BaseMeasurementModal.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 27.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class BaseMeasurementModal : UIViewController
{
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pageContainer : ParentViewController!
    
    @IBOutlet weak var MeasurementLineChart: SpectrumLineChartView!
    
    func goToNextPage() {
        pageContainer.goToNextPage()
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        goToNextPage()
    }
    
    @IBAction func CancelButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func updateLineChart(spectrum : FullRangeInterpolatedSpectrum){
        
        DispatchQueue.main.async {
            //update ui
            if(self.pageContainer.measurmentMode == MeasurementMode.Radiance)
            {
                self.MeasurementLineChart.setAxisValues(min: 0, max: 1.6)
                let radianceSpectrum = SpectrumCalculator.calculateRadiance(spectrum: spectrum)
                self.MeasurementLineChart.data = radianceSpectrum.getChartData()
            }
            else{
                self.MeasurementLineChart.setAxisValues(min: 0, max: 65000)
                self.MeasurementLineChart.data = spectrum.getChartData()
            }
        }
        
    }
}
