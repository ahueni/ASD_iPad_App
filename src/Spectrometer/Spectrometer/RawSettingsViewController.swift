//
//  RawSettingsViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 17.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class RawSettingsViewController: BaseSettingsViewController {
    
    @IBOutlet var darkCurrentSettingsContentHeight: NSLayoutConstraint!
    @IBOutlet var darkCurrentSettingsSwitch: UISwitch!
    
    @IBAction func darkCurrentSettingsSwitchValueChanged(_ sender: UISwitch) {
        // next is only enabled if dc is set off for this raw measurment OR dc is set on and dc exists
        nextButton.isEnabled = !sender.isOn || (sender.isOn && InstrumentStore.sharedInstance.darkCurrent != nil)
        //set correct height for dc section
        self.darkCurrentSettingsContentHeight.constant = sender.isOn ? 60 : 0
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    override func loadSettings()
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
    
    override func addPages(){
        pageContainer!.pages.append(TargetPage(targetCount: Int(targetCountStepper.value), targetDelay: Int(targetDelayStepper.value), takeDarkCurrent: darkCurrentSettingsSwitch.isOn, dataType: DataType.RawType))
    }
    
    override func saveSettings()
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
