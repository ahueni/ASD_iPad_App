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
            
            targetCountStepper.value = Double(loadedSettings.targetCount)
            targetDelayStepper.value = Double(loadedSettings.targetDelay)
        }
    }
    
    override func addPages() {
        pageContainer!.pages.append(WhiteReferenceReflectancePage())
        pageContainer!.pages.append(TargetPage(targetCount: Int(targetCountStepper.value), targetDelay: Int(targetDelayStepper.value)))
    }
    
    override func saveSettings()
    {
        let settings = ReflectanceSettings(targetCount: Int(targetCountStepper.value), targetDelay: Int(targetDelayStepper.value), takeWhiteRefrenceBefore: true)
        
        let settingsData = NSKeyedArchiver.archivedData(withRootObject: settings)
        UserDefaults.standard.set(settingsData, forKey: "ReflectanceSettings")
        UserDefaults.standard.synchronize()
    }

    
    
}



