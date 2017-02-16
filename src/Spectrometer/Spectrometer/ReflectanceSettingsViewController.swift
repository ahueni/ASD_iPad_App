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
    
    // MARK: WhiteReference settings
    @IBOutlet var darkCurrentSettingsContentHeight: NSLayoutConstraint!
    
    @IBAction func darkCurrentSettingsSwitchValueChanged(_ sender: UISwitch) {
        
        if sender.isOn {
            self.darkCurrentSettingsContentHeight.constant = 60
        } else {
            self.darkCurrentSettingsContentHeight.constant = 0
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
        
    }
    
    // MARK: Target settings
    @IBOutlet var targetCountLabel: UILabel!
    @IBOutlet var targetIntervallLabel: UILabel!
    
    
    @IBAction func targetCountStepperValueChanged(_ sender: UIStepper) {
        targetCountLabel.text = Int(sender.value).description
    }
    
    @IBAction func targetIntervallStepperValueChanged(_ sender: UIStepper) {
        targetIntervallLabel.text = Int(sender.value).description
    }
    
    
    
    
    
}



