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
    
    // MARK: Raw settings
    @IBOutlet var darkCurrentSettingsContentHeight: NSLayoutConstraint!
    
    @IBOutlet var darkCurrentSettingsSwitch: UISwitch!
    
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
    
    override func viewDidLoad() {
        loadSettings()
    }
    
    func loadSettings()
    {
        let rawSettings = UserDefaults.standard.data(forKey: "RawSettings")
        
        if(rawSettings != nil){
            
            let loadedSettings = NSKeyedUnarchiver.unarchiveObject(with: rawSettings!) as! RawSettings
            
            darkCurrentSettingsSwitch.isOn = loadedSettings.takeDarkCurrent
            darkCurrentSettingsSwitchValueChanged(darkCurrentSettingsSwitch)
            
            targetCountStepper.value = Double(loadedSettings.targetCount)
            targetCountLabel.text = Int(targetCountStepper.value).description
            
            targetDelayStepper.value = Double(loadedSettings.targetDelay)
            targetIntervallLabel.text = Int(targetDelayStepper.value).description
            
            
        }

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
        addPages()
        super.goToNextPage()
    }
    
    func addPages(){
        pageContainer!.pages.append(TargetPage(targetCount: Int(targetCountStepper.value), targetDelay: Int(targetDelayStepper.value)))
    }
    
    func saveSettings()
    {
        let takeDC = darkCurrentSettingsSwitch.isOn
        let targetCountValue = Int(targetCountStepper.value)
        let targetDelayValue = Int(targetDelayStepper.value)
        
        let settings = RawSettings(takeDarkCurrent: takeDC, targetCount: targetCountValue, targetDelay: targetDelayValue)
        
        let settingsData = NSKeyedArchiver.archivedData(withRootObject: settings)
        UserDefaults.standard.set(settingsData, forKey: "RawSettings")
        UserDefaults.standard.synchronize()
    }
    
    
    
}
