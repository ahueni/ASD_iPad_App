//
//  RadianceSettingsViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 14.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class RadianceSettingsViewController : BaseMeasurementModal {
    
    // MARK: DarkCurrent settings
    @IBOutlet weak var darkCurrentSwitch: UISwitch!
    @IBOutlet var darkCurrentContentHeight: NSLayoutConstraint!
    
    @IBAction func darkCurrentSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.darkCurrentContentHeight.constant = 95
        } else {
            self.darkCurrentContentHeight.constant = 0
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func takeDarkCurrentPressed(_ sender: UIButton) {
        
        
        
    }
    
    
    // MARK: WhiteReference before settings
    @IBOutlet weak var whiteReferenceBeforeSwitch: UISwitch!
    @IBOutlet var whiteReferenceBeforeContentHeight: NSLayoutConstraint!
    
    @IBAction func whiteReferenceBeforeSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            self.whiteReferenceBeforeContentHeight.constant = 78
        } else {
            self.whiteReferenceBeforeContentHeight.constant = 0
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBOutlet weak var whiteReferenceBeforeCountLabel: UILabel!
    @IBOutlet weak var whiteReferenceBeforeCountStepper: UIStepper!
    
    @IBAction func whiteReferenceBeforeCountStepperValueChanged(_ sender: UIStepper) {
        whiteReferenceBeforeCountLabel.text = Int(sender.value).description
    }
    
    @IBOutlet var whiteReferenceBeforeIntervalLabel: UILabel!
    @IBOutlet var whiteReferenceBeforeIntervalStepper: UIStepper!
    
    @IBAction func whiteReferenceBeforeIntervalStepperValueChanged(_ sender: UIStepper) {
        whiteReferenceBeforeIntervalLabel.text = Int(sender.value).description
    }
    
    // MARK: Target settings
    @IBOutlet weak var targetCountLabel: UILabel!
    @IBOutlet weak var targetCountStepper: UIStepper!
    
    @IBAction func targetCountStepperValueChanged(_ sender: UIStepper) {
        targetCountLabel.text = Int(sender.value).description
    }
    
    @IBOutlet var targetIntervalLabel: UILabel!
    @IBOutlet var targetIntervalStepper: UIStepper!
    
    @IBAction func targetIntervalStepperValueChanged(_ sender: UIStepper) {
        targetIntervalLabel.text = Int(sender.value).description
    }
    
    // MARK: WhiteReference after settings
    @IBOutlet weak var whiteRefrenceAfterSwitch: UISwitch!
    @IBOutlet weak var whiteRefrenceAfterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var whiteRefrenceAfterContentView: UIView!
    
    @IBAction func whiteRefrenceAfterSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            self.whiteRefrenceAfterHeightConstraint.constant = 78
        } else {
            self.whiteRefrenceAfterHeightConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBOutlet weak var whiteRefrenceAfterCountLabel: UILabel!
    @IBOutlet weak var whiteRefrenceAfterCountStepper: UIStepper!
    
    @IBAction func whiteRefrenceAfterCountStepperValueChanged(_ sender: UIStepper) {
        whiteRefrenceAfterCountLabel.text = Int(sender.value).description
    }
    
    @IBOutlet var whiteReferenceAfterIntervalLabel: UILabel!
    @IBOutlet var whiteReferenceAfterIntervalStepper: UIStepper!
    
    @IBAction func whiteReferenceAfterIntervalStepperValueChanged(_ sender: UIStepper) {
        whiteReferenceAfterIntervalLabel.text = Int(sender.value).description
    }
    
    
    
    override func goToNextPage() {
        pageContainer?.settings = RadianceSettings(targetCount: Int(targetCountStepper.value), targetDelay: 0, takeWhiteRefrenceBefore: whiteReferenceBeforeSwitch.isOn, whiteRefrenceBeforeCount: Int(whiteReferenceBeforeCountStepper.value), takeWhiteRefrenceAfter: whiteRefrenceAfterSwitch.isOn, whiteRefrenceAfterCount: Int(whiteRefrenceAfterCountStepper.value), whiteRefrenceBeforeDelay : 0, whiteRefrenceAfterDelay : 0)
    }
    
}
