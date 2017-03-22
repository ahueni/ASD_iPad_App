//
//  InstrumentControlViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 03.03.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class InstrumentControlViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var instrumentControlValues : ICValues!
    
    @IBOutlet var integrationTimeTextField: NumberTextField!
    @IBOutlet var swir1GainTextField: NumberTextField!
    @IBOutlet var swir1OffsetTextField: NumberTextField!
    @IBOutlet var swir2GainTextField: NumberTextField!
    @IBOutlet var swir2OffsetTextField: NumberTextField!
    
    let alert = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
    
    override func viewDidLoad() {
        
        
        let acitivty = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = acitivty
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        
        self.present(alert, animated: true, completion: nil)
        
        DispatchQueue.global().async {
            self.loadInstrumentControlValues()
        }
    }
    
    func loadInstrumentControlValues(){
        CommandManager.sharedInstance.aquire(samples: 2, successCallBack: self.acquireSuccess, errorCallBack: self.acquireError)
    }
    
    func acquireSuccess(spectrum: FullRangeInterpolatedSpectrum) -> Void {
        
        let integrationTime = spectrum.spectrumHeader.vinirHeader.integrationTime
        let swir1Gain = spectrum.spectrumHeader.swir1Header.gain
        let swir1Offset = spectrum.spectrumHeader.swir1Header.offset
        let swir2Gain = spectrum.spectrumHeader.swir2Header.gain
        let swir2Offset = spectrum.spectrumHeader.swir2Header.offset
        
        instrumentControlValues = ICValues(integrationTime: integrationTime, swir1Gain: swir1Gain, swir1Offset: swir1Offset, swir2Gain: swir2Gain, swir2Offset: swir2Offset)
        
        let pickerView = UIPickerView()
        pickerView.showsSelectionIndicator = true
        pickerView.delegate = self
        integrationTimeTextField.inputView = pickerView
        
        self.updateFields()
        
    }
    
    func acquireError(error: Error) {
        fatalError("handle acquire Error")
    }
    
    func updateFields() {
        
        DispatchQueue.main.async {
            self.integrationTimeTextField.text = IntegrationTime.getIntegrationTime(index: self.instrumentControlValues.integrationTime).readableMilis()
            self.swir1GainTextField.text = self.instrumentControlValues.swir1Gain.description
            self.swir1OffsetTextField.text = self.instrumentControlValues.swir1Offset.description
            self.swir2GainTextField.text = self.instrumentControlValues.swir2Gain.description
            self.swir2OffsetTextField.text = self.instrumentControlValues.swir2Offset.description
            
            self.alert.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @IBAction func Update(_ sender: UIButton) {
        
        instrumentControlValues.swir1Gain = swir1GainTextField.number
        instrumentControlValues.swir1Offset = swir1OffsetTextField.number
        instrumentControlValues.swir2Gain = swir2GainTextField.number
        instrumentControlValues.swir2Offset = swir2OffsetTextField.number
        
        CommandManager.sharedInstance.setInstrumentControl(instrumentControlValues: instrumentControlValues, errorCallBack: self.updateError)
    }
    
    @IBAction func performOptimize(_ sender: UIButton){
        CommandManager.sharedInstance.optimize(successCallBack: {
            self.loadInstrumentControlValues()
            self.updateFields()
        }, errorCallBack: self.optimizeError)
    }
    
    // picker view configuration
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return IntegrationTime.integrationTimes.count
    }
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return IntegrationTime.integrationTimes[row].1.readableMilis()
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // selected integration time
        let integrationTime = IntegrationTime.integrationTimes[row]
        
        // update text field
        integrationTimeTextField.text = integrationTime.1.readableMilis()
        instrumentControlValues.integrationTime = integrationTime.0
        
    }
    
    private func optimizeError(error: Error) {
        self.showWarningMessage(title: "Error", message: "Could not perform optimize command")
    }
    
    private func updateError(error: Error) {
        self.showWarningMessage(title: "Error", message: "Could not perform update instrument")
    }
    
    
}

struct ICValues {
    
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
