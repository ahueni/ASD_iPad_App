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
    
    @IBOutlet weak var targetDelayStepper: UIStepper!
    @IBOutlet weak var targetCountStepper: UIStepper!
    @IBOutlet var targetCountLabel: UILabel!
    @IBOutlet var targetIntervallLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    override func viewDidLoad() {
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
        targetIntervallLabel.text = Int(targetDelayStepper.value).description
    }
    
    @IBAction func takeDarkCurrentPressed(_ sender: UIButton) {
        let darkCurrentSampleCount = InstrumentSettingsCache.sharedInstance.instrumentConfiguration.sampleCountDarkCurrent
        CommandManager.sharedInstance.darkCurrent(sampleCount: darkCurrentSampleCount)
        nextButton.isEnabled = true
    }
    
    override func goToNextPage() {
        saveSettings()
        addPages()
        super.goToNextPage()
    }
}
