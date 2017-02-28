							//
//  RadianceSettingsViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 14.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class RadianceSettingsViewController : BaseSettingsViewController, SelectFiberopticDelegate {
    
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
    
    // White Reference After
    @IBOutlet var whiteRefrenceAfterSwitch: UISwitch!
    @IBOutlet var whiteRefrenceAfterHeightConstraint: NSLayoutConstraint!
    @IBOutlet var whiteRefrenceAfterCountStepper: UIStepper!
    @IBOutlet var whiteRefrenceAfterCountLabel: UILabel!
    @IBOutlet var whiteReferenceAfterIntervalLabel: UILabel!
    @IBOutlet var whiteReferenceAfterIntervalStepper: UIStepper!
        
    @IBAction func foreOpticButtonClicked(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SelectFiberOpticTableViewController") as!SelectFiberOpticTableViewController
        vc.delegate = self
        vc.modalPresentationStyle = .popover
        let popover = vc.popoverPresentationController!
        popover.permittedArrowDirections = [.left, .up]
        popover.sourceView = sender
        popover.sourceRect = sender.bounds
        self.present(vc, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = InstrumentSettingsCache.sharedInstance.darkCurrent != nil
    }
    
    internal func didSelectFiberoptic(fiberoptic: CalibrationFile) {
        InstrumentSettingsCache.sharedInstance.selectedForeOptic = fiberoptic
    }
    
    override func loadSettings(){
        let radianceSettings = UserDefaults.standard.data(forKey: "RadianceSettings")
        if(radianceSettings != nil){
            let loadedSettings = NSKeyedUnarchiver.unarchiveObject(with: radianceSettings!) as! RadianceSettings
            
            // init white Ref BEFORE section
            whiteReferenceBeforeSwitch.isOn = loadedSettings.takeWhiteRefrenceBefore
            whiteReferenceBeforeSwitchValueChanged(whiteReferenceBeforeSwitch)
            whiteReferenceBeforeCountStepper.value = Double(loadedSettings.whiteRefrenceBeforeCount)
            whiteReferenceBeforeIntervalStepper.value = Double(loadedSettings.whiteRefrenceBeforeDelay)
            
            // init target section
            targetCountStepper.value = Double(loadedSettings.targetCount)
            targetDelayStepper.value = Double(loadedSettings.targetDelay)
            
            // init white Ref AFTER section
            whiteRefrenceAfterSwitch.isOn = loadedSettings.takeWhiteRefrenceAfter
            whiteRefrenceAfterSwitchValueChanged(whiteRefrenceAfterSwitch)
            whiteRefrenceAfterCountStepper.value = Double(loadedSettings.whiteRefrenceAfterCount)
            whiteReferenceAfterIntervalStepper.value = Double(loadedSettings.whiteRefrenceAfterDelay)
        }
        updateStepperLabels()
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
    
    override func updateStepperLabels()
    {
        whiteReferenceBeforeCountLabel.text = Int(whiteReferenceBeforeCountStepper.value).description
        whiteReferenceBeforeIntervalLabel.text = Int(whiteReferenceBeforeIntervalStepper.value).description
        targetCountLabel.text = Int(targetCountStepper.value).description
        targetIntervallLabel.text = Int(targetDelayStepper.value).description
        whiteRefrenceAfterCountLabel.text = Int(whiteRefrenceAfterCountStepper.value).description
        whiteReferenceAfterIntervalLabel.text = Int(whiteReferenceAfterIntervalStepper.value).description
        super.updateStepperLabels()
    }
    
    override func addPages(){
        // add before whiteReferencePage if switch is on
        if(whiteReferenceBeforeSwitch.isOn)
        {
            pageContainer!.pages.append(WhiteReferenceRadiancePage(whiteReferenceCount: Int(whiteReferenceBeforeCountStepper.value), whiteReferenceDelay: Int(whiteReferenceBeforeIntervalStepper.value), whiteRefrenceEnum: .Before))
        }
        // target is not optional => include it anyway
        pageContainer!.pages.append(TargetPage(targetCount: Int(targetCountStepper.value), targetDelay: Int(targetDelayStepper.value)))
        
        // add after whiteReferencePage if switch is on
        if(whiteRefrenceAfterSwitch.isOn)
        {
            pageContainer!.pages.append(WhiteReferenceRadiancePage(whiteReferenceCount: Int(whiteRefrenceAfterCountStepper.value), whiteReferenceDelay: Int(whiteReferenceAfterIntervalStepper.value), whiteRefrenceEnum: .After))
        }
    }
    
    override func saveSettings()
    {
        let settings = RadianceSettings(targetCount: Int(targetCountStepper.value), targetDelay: Int(targetDelayStepper.value), takeWhiteRefrenceBefore: whiteReferenceBeforeSwitch.isOn, whiteRefrenceBeforeCount: Int(whiteReferenceBeforeCountStepper.value), takeWhiteRefrenceAfter: whiteRefrenceAfterSwitch.isOn, whiteRefrenceAfterCount: Int(whiteRefrenceAfterCountStepper.value), whiteRefrenceBeforeDelay : Int(whiteReferenceBeforeIntervalStepper.value), whiteRefrenceAfterDelay : Int(whiteReferenceAfterIntervalStepper.value))
        
        let settingsData = NSKeyedArchiver.archivedData(withRootObject: settings)
        UserDefaults.standard.set(settingsData, forKey: "RadianceSettings")
        UserDefaults.standard.synchronize()
    }
    
}
