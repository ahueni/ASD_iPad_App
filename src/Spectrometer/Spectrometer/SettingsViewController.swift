//
//  SettingsViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 17.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController : UIViewController{
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var TextFieldSampleCount: UITextField!
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        
        appDelegate.config?.sampleCount = Int32(TextFieldSampleCount.text!)!
        appDelegate.saveContext()
        
    }
    
    override func viewDidLoad() {
        TextFieldSampleCount.text = appDelegate.config?.sampleCount.description
    }
}
