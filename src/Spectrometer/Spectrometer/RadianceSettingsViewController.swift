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
    
    // DarkCurrent
    @IBOutlet var darkCurrentSwitch: UISwitch!
    @IBOutlet var darkCurrentContentHeight: NSLayoutConstraint!
    
    // White Reference Before
    @IBOutlet var whiteReferenceBeforeSwitch: UISwitch!
    @IBOutlet var whiteReferenceBeforeContentHeight: NSLayoutConstraint!
    @IBOutlet var whiteReferenceBeforeCountLabel: UILabel!
    @IBOutlet var whiteReferenceBeforeCountStepper: UIStepper!
    @IBOutlet var whiteReferenceBeforeIntervalLabel: UILabel!
    @IBOutlet var whiteReferenceBeforeIntervalStepper: UIStepper!
    
    // Target
    @IBOutlet var targetCountLabel: UILabel!
    @IBOutlet var targetCountStepper: UIStepper!
    @IBOutlet var targetIntervalLabel: UILabel!
    @IBOutlet var targetIntervalStepper: UIStepper!
    
    // White Reference After
    @IBOutlet var whiteRefrenceAfterSwitch: UISwitch!
    @IBOutlet var whiteRefrenceAfterHeightConstraint: NSLayoutConstraint!
    @IBOutlet var whiteRefrenceAfterCountStepper: UIStepper!
    @IBOutlet var whiteRefrenceAfterCountLabel: UILabel!
    @IBOutlet var whiteReferenceAfterIntervalLabel: UILabel!
    @IBOutlet var whiteReferenceAfterIntervalStepper: UIStepper!
    
    override func viewDidLoad() {
        loadSettingsIfExist()
        updateStepperLabels()
    }
    
    func loadSettingsIfExist(){
        let radianceSettings = UserDefaults.standard.data(forKey: "RadianceSettings")
        if(radianceSettings != nil){
            let loadedSettings = NSKeyedUnarchiver.unarchiveObject(with: radianceSettings!) as! RadianceSettings
            
            whiteReferenceBeforeCountStepper.value = Double(loadedSettings.whiteRefrenceBeforeCount)
            whiteReferenceBeforeIntervalStepper.value = Double(loadedSettings.whiteRefrenceBeforeDelay)
            targetCountStepper.value = Double(loadedSettings.targetCount)
            targetIntervalStepper.value = Double(loadedSettings.targetDelay)
            whiteRefrenceAfterCountStepper.value = Double(loadedSettings.whiteRefrenceAfterCount)
            whiteReferenceAfterIntervalStepper.value = Double(loadedSettings.whiteRefrenceAfterDelay)
        }
    }
    
    
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
    
    @IBAction func whiteReferenceBeforeCountStepperValueChanged(_ sender: UIStepper) {
        updateStepperLabels()
    }
    
    @IBAction func whiteReferenceBeforeIntervalStepperValueChanged(_ sender: UIStepper) {
        updateStepperLabels()
    }
    
    @IBAction func targetCountStepperValueChanged(_ sender: UIStepper) {
        updateStepperLabels()
    }
    
    @IBAction func targetIntervalStepperValueChanged(_ sender: UIStepper) {
        updateStepperLabels()
    }
    
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
    
    @IBAction func whiteRefrenceAfterCountStepperValueChanged(_ sender: UIStepper) {
        updateStepperLabels()
    }
    
    @IBAction func whiteReferenceAfterIntervalStepperValueChanged(_ sender: UIStepper) {
        updateStepperLabels()
    }
    
    func updateStepperLabels()
    {
        whiteReferenceBeforeCountLabel.text = Int(whiteReferenceBeforeCountStepper.value).description
        whiteReferenceBeforeIntervalLabel.text = Int(whiteReferenceBeforeIntervalStepper.value).description
        targetCountLabel.text = Int(targetCountStepper.value).description
        targetIntervalLabel.text = Int(targetIntervalStepper.value).description
        whiteRefrenceAfterCountLabel.text = Int(whiteRefrenceAfterCountStepper.value).description
        whiteReferenceAfterIntervalLabel.text = Int(whiteReferenceAfterIntervalStepper.value).description
    }
    
    override func goToNextPage() {
        saveSettings()
        
        if(whiteReferenceBeforeSwitch.isOn)
        {
            pageContainer!.pages.append(WhiteReferenceRadiancePage(whiteReferenceCount: Int(whiteReferenceBeforeCountStepper.value), whiteReferenceDelay: Int(whiteReferenceBeforeIntervalStepper.value), whiteRefrenceEnum: .Before))
        }
        pageContainer!.pages.append(TargetPage(targetCount: Int(targetCountStepper.value), targetDelay: Int(targetIntervalStepper.value)))
        
        if(whiteRefrenceAfterSwitch.isOn)
        {
            pageContainer!.pages.append(WhiteReferenceRadiancePage(whiteReferenceCount: Int(whiteRefrenceAfterCountStepper.value), whiteReferenceDelay: Int(whiteReferenceAfterIntervalStepper.value), whiteRefrenceEnum: .After))
        }
        
        super.goToNextPage()
    }
    
    func saveSettings()
    {
        let settings = RadianceSettings(targetCount: Int(targetCountStepper.value), targetDelay: Int(targetIntervalStepper.value), takeWhiteRefrenceBefore: whiteReferenceBeforeSwitch.isOn, whiteRefrenceBeforeCount: Int(whiteReferenceBeforeCountStepper.value), takeWhiteRefrenceAfter: whiteRefrenceAfterSwitch.isOn, whiteRefrenceAfterCount: Int(whiteRefrenceAfterCountStepper.value), whiteRefrenceBeforeDelay : Int(whiteReferenceBeforeIntervalStepper.value), whiteRefrenceAfterDelay : Int(whiteReferenceAfterIntervalStepper.value))
        
        let settingsData = NSKeyedArchiver.archivedData(withRootObject: settings)
        UserDefaults.standard.set(settingsData, forKey: "RadianceSettings")
        UserDefaults.standard.synchronize()
    }
    
}
