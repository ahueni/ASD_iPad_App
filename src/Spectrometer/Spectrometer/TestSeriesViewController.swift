//
//  TestSeriesViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 18.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class TestSeriesViewController : UIViewController {
    
    var pageIndex: Int = 0
    var strTitle: String!
    var pageContainer : ParentViewController? = nil
    var measurmentSettings : MeasurmentSettings? = nil
    
    @IBOutlet weak var whiteRefrenceSettingsSegmentControl: UISegmentedControl!
    @IBOutlet weak var measurementCountTextField: UITextField!
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        goToNextPage()
    }
    
    func goToNextPage(){
            measurmentSettings?.measurementCount = Int(measurementCountTextField.text!)!
            switch whiteRefrenceSettingsSegmentControl.selectedSegmentIndex {
            case 0:
                measurmentSettings?.whiteRefrenceSetting = WhiteRefrenceSettings.TakeOnce
            default:
                measurmentSettings?.whiteRefrenceSetting = WhiteRefrenceSettings.TakeBeforeMesurement
            }
        
        pageContainer?.goToNextPage()
    }
    
    @IBAction func CancelButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}