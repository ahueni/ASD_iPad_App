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
    var pageContainer : ParentViewController? = nil
    
    @IBOutlet weak var MeasurementLineChart: SpectrumLineChartView!
    
    func goToNextPage() {
        pageContainer?.goToNextPage()
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
            self.MeasurementLineChart.setAxisValues(min: 0, max: 65000)
            self.MeasurementLineChart.data = spectrum.getChartData()
        }
        
    }
}
