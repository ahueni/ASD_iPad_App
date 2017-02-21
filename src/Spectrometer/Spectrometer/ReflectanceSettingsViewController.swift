//
//  ReflectanceSettingsViewController.swift
//  Spectrometer
//
//  Created by raphi on 14.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class ReflectanceSettingsViewController : RawSettingsViewController {
    
    override func loadSettings() {
        let reflectanceSettings = UserDefaults.standard.data(forKey: "ReflectanceSettings")
        if(reflectanceSettings != nil){
            let loadedSettings = NSKeyedUnarchiver.unarchiveObject(with: reflectanceSettings!) as! ReflectanceSettings
            
            darkCurrentSettingsSwitch.isOn = loadedSettings.takeDarkCurrent
            darkCurrentSettingsSwitchValueChanged(darkCurrentSettingsSwitch)
            
            targetCountStepper.value = Double(loadedSettings.targetCount)
            targetCountLabel.text = loadedSettings.targetCount.description
            
            targetDelayStepper.value = Double(loadedSettings.targetDelay)
            targetIntervallLabel.text = loadedSettings.targetDelay.description
        }
    }
    
    override func addPages() {
        pageContainer!.pages.append(WhiteReferenceReflectancePage())
        pageContainer!.pages.append(TargetPage(targetCount: Int(targetCountStepper.value), targetDelay: Int(targetDelayStepper.value)))
    }
    
    override func saveSettings()
    {
        let takeDC = darkCurrentSettingsSwitch.isOn
        let targetCountValue = Int(targetCountStepper.value)
        let targetDelayValue = Int(targetDelayStepper.value)
        
        let settings = ReflectanceSettings(takeDarkCurrent: takeDC, targetCount: targetCountValue, targetDelay: targetDelayValue, takeWhiteRefrenceBefore: true)
        
        let settingsData = NSKeyedArchiver.archivedData(withRootObject: settings)
        UserDefaults.standard.set(settingsData, forKey: "ReflectanceSettings")
        UserDefaults.standard.synchronize()
    }

    
    
}



