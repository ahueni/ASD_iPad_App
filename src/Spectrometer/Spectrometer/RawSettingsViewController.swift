//
//  RawSettingsViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 17.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class RawSettingsViewController : BaseMeasurementModal {
    
    // MARK: WhiteReference settings
    @IBOutlet var darkCurrentSettingsContentHeight: NSLayoutConstraint!
    
    @IBOutlet weak var targetDelayStepper: UIStepper!
    @IBOutlet weak var targetCountStepper: UIStepper!
    
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
    
    override func goToNextPage() {
        saveSettings()
        pageContainer!.pages.append(TargetPage(targetCount: Int(targetCountStepper.value), targetDelay: Int(targetDelayStepper.value)))
        super.goToNextPage()
    }
    
    func saveSettings()
    {
        
    }
    
    
    
}
