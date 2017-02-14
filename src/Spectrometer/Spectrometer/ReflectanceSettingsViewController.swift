//
//  ReflectanceSettingsViewController.swift
//  Spectrometer
//
//  Created by raphi on 14.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class ReflectanceSettingsViewController : BaseMeasurementModal {
    
    @IBOutlet weak var TestHeightConstaint: NSLayoutConstraint!
    
    @IBAction func darkCurrentSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn
        {
            TestHeightConstaint.constant = 51
        }
        else
        {
            
            TestHeightConstaint.constant = 0
        }
    }
}



