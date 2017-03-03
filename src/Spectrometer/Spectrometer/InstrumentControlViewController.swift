//
//  InstrumentControlViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 03.03.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class InstrumentControlViewController : UIViewController{
    
    var instrumentControlValues : ICValues!
    
    @IBOutlet var integrationTimeTextField: NumberTextField!
    @IBOutlet var swir1GainTextField: NumberTextField!
    @IBOutlet var swir1OffsetTextField: NumberTextField!
    @IBOutlet var swir2GainTextField: NumberTextField!
    @IBOutlet var swir2OffsetTextField: NumberTextField!
    
    override func viewDidLoad() {
        loadInstrumentControlValues()
        updateFields()
    }
    
    func updateFields(){
        integrationTimeTextField.text = instrumentControlValues.integrationTime.description
        swir1GainTextField.text = instrumentControlValues.swir1Gain.description
        swir1OffsetTextField.text = instrumentControlValues.swir1Offset.description
        swir2GainTextField.text = instrumentControlValues.swir2Gain.description
        swir2OffsetTextField.text = instrumentControlValues.swir2Offset.description
    }
    
    func loadInstrumentControlValues(){
        let spectrum = CommandManager.sharedInstance.aquire(samples: 1)
        let integrationTime = spectrum.spectrumHeader.vinirHeader.integrationTime
        let swir1Gain = spectrum.spectrumHeader.swir1Header.gain
        let swir1Offset = spectrum.spectrumHeader.swir1Header.offset
        let swir2Gain = spectrum.spectrumHeader.swir2Header.gain
        let swir2Offset = spectrum.spectrumHeader.swir2Header.offset
        instrumentControlValues = ICValues(integrationTime: integrationTime, swir1Gain: swir1Gain, swir1Offset: swir1Offset, swir2Gain: swir2Gain, swir2Offset: swir2Offset)
    }
    
    @IBAction func Update(_ sender: UIButton) {
        instrumentControlValues.integrationTime = integrationTimeTextField.number
        instrumentControlValues.swir1Gain = swir1GainTextField.number
        instrumentControlValues.swir1Offset = swir1OffsetTextField.number
        instrumentControlValues.swir2Gain = swir2GainTextField.number
        instrumentControlValues.swir2Offset = swir2OffsetTextField.number
        CommandManager.sharedInstance.setInstrumentControl(instrumentControlValues: instrumentControlValues)
    }
    
    @IBAction func performOptimize(_ sender: UIButton){
        CommandManager.sharedInstance.optimize()
        loadInstrumentControlValues()
        updateFields()
    }
}

struct ICValues{
    var integrationTime : Int!
    var swir1Gain : Int!
    var swir1Offset : Int!
    var swir2Gain : Int!
    var swir2Offset : Int!
    
    init(integrationTime : Int, swir1Gain : Int, swir1Offset : Int, swir2Gain : Int, swir2Offset : Int) {
        self.integrationTime = integrationTime
        self.swir1Gain = swir1Gain
        self.swir1Offset = swir1Offset
        self.swir2Gain = swir2Gain
        self.swir2Offset = swir2Offset
    }
}
