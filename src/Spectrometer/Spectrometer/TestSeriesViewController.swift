//
//  TestSeriesViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 18.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class StartTestSeriesTableViewController : UITableViewController {
    var pageContainer : ParentViewController? = nil
    
    @IBOutlet weak var fileNameTextField: UITextField!
    @IBOutlet weak var filePathButton: UIButton!
    @IBOutlet weak var measurementCountTextField: UITextField!
    @IBOutlet weak var whiteRefrenceSettingsSegmentControl: UISegmentedControl!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var StartButton: UIButton!
    @IBAction func NameTextFieldEditingChanged(_ sender: Any) {
        validate()
    }
    @IBAction func measurmentCountTextFieldEditingChanged(_ sender: Any) {
        validate()
    }
    
    func validate()
    {
        StartButton.isEnabled = ValidationManager.sharedInstance.validateSubViews(view: view)
    }
}
