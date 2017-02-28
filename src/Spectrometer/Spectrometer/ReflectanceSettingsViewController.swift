//
//  ReflectanceSettingsViewController.swift
//  Spectrometer
//
//  Created by raphi on 14.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class ReflectanceSettingsViewController : BaseMeasurementModal, SettingsProtocol {
    
    @IBOutlet var darkCurrentSettingsContentHeight: NSLayoutConstraint!
    @IBOutlet weak var targetDelayStepper: UIStepper!
    @IBOutlet weak var targetCountStepper: UIStepper!
    @IBOutlet var targetCountLabel: UILabel!
    @IBOutlet var targetIntervallLabel: UILabel!
    
    override func viewDidLoad() {
        loadSettings()
    }
    
    func loadSettings() {
        let reflectanceSettings = UserDefaults.standard.data(forKey: "ReflectanceSettings")
        if(reflectanceSettings != nil){
            let loadedSettings = NSKeyedUnarchiver.unarchiveObject(with: reflectanceSettings!) as! ReflectanceSettings
            
            targetCountStepper.value = Double(loadedSettings.targetCount)
            targetCountLabel.text = loadedSettings.targetCount.description
            
            targetDelayStepper.value = Double(loadedSettings.targetDelay)
            targetIntervallLabel.text = loadedSettings.targetDelay.description
        }
    }
    
    func addPages() {
        pageContainer!.pages.append(WhiteReferenceReflectancePage())
        pageContainer!.pages.append(TargetPage(targetCount: Int(targetCountStepper.value), targetDelay: Int(targetDelayStepper.value)))
    }
    
    override func goToNextPage() {
        addPages()
        super.goToNextPage()
    }
    
    func saveSettings()
    {
        let targetCountValue = Int(targetCountStepper.value)
        let targetDelayValue = Int(targetDelayStepper.value)
        
        let settings = ReflectanceSettings(targetCount: targetCountValue, targetDelay: targetDelayValue, takeWhiteRefrenceBefore: true)
        
        let settingsData = NSKeyedArchiver.archivedData(withRootObject: settings)
        UserDefaults.standard.set(settingsData, forKey: "ReflectanceSettings")
        UserDefaults.standard.synchronize()
    }

    
    
}



