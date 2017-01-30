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
    
    @IBOutlet weak var SampleCountSpectrumValueLabel: UILabel!
    @IBOutlet weak var SampleCountSpectrumSlider: UISlider!
    @IBOutlet weak var SampleCountDarkCurrentValueLabel: UILabel!
    @IBOutlet weak var SampleCountWhiteRefrenceValueLabel: UILabel!
    @IBOutlet weak var SampleCountDarkCurrentSlider: UISlider!
    @IBOutlet weak var SampleCountWhiteRefrenceSlider: UISlider!
    
    @IBAction func SampleCountSliderValueChanged(_ sender: UISlider) {
        SampleCountSpectrumValueLabel.text = Int(SampleCountSpectrumSlider.value).description
        SampleCountDarkCurrentValueLabel.text = Int(SampleCountDarkCurrentSlider.value).description
        SampleCountWhiteRefrenceValueLabel.text = Int(SampleCountWhiteRefrenceSlider.value).description
    }
    
    override func viewDidLoad() {
        SampleCountSpectrumValueLabel.text = appDelegate.config!.sampleCount.description
        SampleCountDarkCurrentValueLabel.text = appDelegate.config!.sampleCountDarkCurrent.description
        SampleCountWhiteRefrenceValueLabel.text = appDelegate.config!.sampleCountWhiteRefrence.description
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        appDelegate.config!.sampleCount = Int32(SampleCountSpectrumSlider.value)
        appDelegate.config!.sampleCountDarkCurrent = Int32(SampleCountDarkCurrentSlider.value)
        appDelegate.config!.sampleCountWhiteRefrence = Int32(SampleCountWhiteRefrenceSlider.value)
        appDelegate.saveContext()
    }
}
