//
//  SettingsProtocol.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 28.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class BaseSettingsViewController : BaseMeasurementModal {
    
    @IBOutlet var targetDelayStepper: UIStepper!
    @IBOutlet var targetCountStepper: UIStepper!
    @IBOutlet var targetCountLabel: UILabel!
    @IBOutlet var targetIntervallLabel: UILabel!
    
    @IBOutlet var darkCurrentTimerLabel: UILabel!
    
    override func viewDidLoad() {
        
        // register labels for timer updateStepperLabels
        NotificationCenter.default.addObserver(self, selector: #selector(updateDarkCurrentTimerLabel), name: .darkCurrentTimer, object: nil)
        
        loadSettings()
    }
    
    // Swift does not support abstract classes. This is the only way to make sure the derived classes do override this method
    func loadSettings(){
        fatalError("Must Override")
    }
    
    // Swift does not support abstract classes. This is the only way to make sure the derived classes do override this method
    func saveSettings(){
        fatalError("Must Override")
    }
    
    // Swift does not support abstract classes. This is the only way to make sure the derived classes do override this method
    func addPages(){
        fatalError("Must Override")
    }
    
    @IBAction func targetCountStepperValueChanged(_ sender: UIStepper) {
        updateStepperLabels()
    }
    
    @IBAction func targetIntervallStepperValueChanged(_ sender: UIStepper) {
        updateStepperLabels()
    }
    
    func updateStepperLabels()
    {
        targetCountLabel.text = Int(targetCountStepper.value).description
        targetIntervallLabel.text = Int(targetDelayStepper.value).description + " [s]"
    }
    
    @IBAction func takeDarkCurrentPressed(_ sender: LoadingButton) {
        sender.showLoading()
        
        DispatchQueue.global().async {
            
            let darkCurrentSampleCount = ViewStore.sharedInstance.instrumentConfiguration.sampleCountDarkCurrent
            CommandManager.sharedInstance.darkCurrent(sampleCount: darkCurrentSampleCount)
            
            
            DispatchQueue.main.async {
                
                ViewStore.sharedInstance.restartDarkCurrentTimer()
                self.nextButton.isEnabled = true
                sender.hideLoading()
                
            }
            
        }
        
    }
    
    override func goToNextPage() {
        saveSettings()
        addPages()
        super.goToNextPage()
    }
    
    internal func updateDarkCurrentTimerLabel() {
        
        if let darkCurrentStartTime = ViewStore.sharedInstance.darkCurrentStartTime {
            let elapsedTime = NSDate.timeIntervalSinceReferenceDate - darkCurrentStartTime
            darkCurrentTimerLabel.text = elapsedTime.getHHMMSS()
        }
        
    }
    
}
