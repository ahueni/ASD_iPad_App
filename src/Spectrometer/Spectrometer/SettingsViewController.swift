//
//  SettingsViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 17.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController : UITableViewController{
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        SampleCountSpectrumValueLabel.text = InstrumentStore.sharedInstance.instrumentConfiguration.sampleCount.description
        SampleCountDarkCurrentValueLabel.text = InstrumentStore.sharedInstance.instrumentConfiguration.sampleCountDarkCurrent.description
        SampleCountWhiteRefrenceValueLabel.text = InstrumentStore.sharedInstance.instrumentConfiguration.sampleCountWhiteRefrence.description
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        InstrumentStore.sharedInstance.instrumentConfiguration.sampleCount = Int32(SampleCountSpectrumSlider.value)
        InstrumentStore.sharedInstance.instrumentConfiguration.sampleCountDarkCurrent = Int32(SampleCountDarkCurrentSlider.value)
        InstrumentStore.sharedInstance.instrumentConfiguration.sampleCountWhiteRefrence = Int32(SampleCountWhiteRefrenceSlider.value)
        appDelegate.saveContext()
    }
}
