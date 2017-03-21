//
//  BaseMeasurementModal.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 27.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit
import Charts

struct LineChartDataContainer{
    var currentLineChart : LineChartDataSet!
    var lineChartPool : [LineChartDataSet] = []
}

class BaseMeasurementModal : UIViewController
{
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pageContainer : ParentViewController!
    
    @IBOutlet var nextButton: UIButton!
    
    func goToNextPage() {
        pageContainer.goToNextPage()
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        goToNextPage()
    }
    
    @IBAction func CancelButtonClicked(_ sender: UIButton) {
        ViewStore.sharedInstance.cancelMeasurment = true
        dismiss(animated: true, completion: nil)
    }
    
    func acquireError(error: Error) -> Void {
        ViewStore.sharedInstance.cancelMeasurment = true
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
        let closeAction = UIAlertAction(title: "Ok", style: .default, handler: {
            alert in self.dismiss(animated: true, completion: nil)
        })
        alert.addAction(closeAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
