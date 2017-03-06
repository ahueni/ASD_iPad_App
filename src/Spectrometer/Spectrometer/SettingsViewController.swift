//
//  SettingsViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 17.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class InstrumentSettingsViewController : UITableViewController {
    
    @IBOutlet var SampleCountSpectrumValueLabel: UILabel!
    @IBOutlet var SampleCountSpectrumSlider: UISlider!
    @IBOutlet var SampleCountDarkCurrentValueLabel: UILabel!
    @IBOutlet var SampleCountWhiteRefrenceValueLabel: UILabel!
    @IBOutlet var SampleCountDarkCurrentSlider: UISlider!
    @IBOutlet var SampleCountWhiteRefrenceSlider: UISlider!
    
    @IBAction func SampleCountSliderValueChanged(_ sender: UISlider) {
        SampleCountSpectrumValueLabel.text = Int(SampleCountSpectrumSlider.value).description
        SampleCountDarkCurrentValueLabel.text = Int(SampleCountDarkCurrentSlider.value).description
        SampleCountWhiteRefrenceValueLabel.text = Int(SampleCountWhiteRefrenceSlider.value).description
    }
    
    override func viewDidLoad() {
        SampleCountSpectrumValueLabel.text = ViewStore.sharedInstance.instrumentConfiguration.sampleCount.description
        SampleCountDarkCurrentValueLabel.text = ViewStore.sharedInstance.instrumentConfiguration.sampleCountDarkCurrent.description
        SampleCountWhiteRefrenceValueLabel.text = ViewStore.sharedInstance.instrumentConfiguration.sampleCountWhiteRefrence.description
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        ViewStore.sharedInstance.instrumentConfiguration.sampleCount = Int32(SampleCountSpectrumSlider.value)
        ViewStore.sharedInstance.instrumentConfiguration.sampleCountDarkCurrent = Int32(SampleCountDarkCurrentSlider.value)
        ViewStore.sharedInstance.instrumentConfiguration.sampleCountWhiteRefrence = Int32(SampleCountWhiteRefrenceSlider.value)
    }
}
