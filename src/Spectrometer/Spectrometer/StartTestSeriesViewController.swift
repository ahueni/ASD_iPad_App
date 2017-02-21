//
//  TestSeriesViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 18.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class StartTestSeriesViewController : BaseMeasurementModal, UITextFieldDelegate, SelectPathDelegate {
    
    @IBOutlet var fileNameTextField: UITextField!
    @IBOutlet var selectPathInput: SelectInputPath! 
    @IBOutlet var nextButton: UIColorButton!
    
    @IBOutlet var rawRadioButton: RadioButton!
    @IBOutlet var reflectanceRadioButton: RadioButton!
    @IBOutlet var radianceRadioButton: RadioButton!
    
    override func viewDidLoad() {
        
        // add delegates
        fileNameTextField.delegate = self;
        selectPathInput.delegate = self
        
        // initialize measurement mode buttons
        rawRadioButton.alternateButton = [radianceRadioButton, reflectanceRadioButton]
        radianceRadioButton.alternateButton = [rawRadioButton, reflectanceRadioButton]
        reflectanceRadioButton.alternateButton = [rawRadioButton, radianceRadioButton]
        
        // click anywhere to close keyboard
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        // initialize last setting values and update it on the view
        loadSettingsIfExist()
    }
    
    func loadSettingsIfExist(){
        let _loadedSettings = UserDefaults.standard.data(forKey: "MeasurmentSettings")
        if let loadedSettings = _loadedSettings {
            let measurementSettings = NSKeyedUnarchiver.unarchiveObject(with: loadedSettings) as! MeasurmentSettings
            
            fileNameTextField.text = measurementSettings.fileName
            
            // not working - recreate a url from NSUserDefaults is not possible
            //selectPathInput.update(diskFile: measurementSettings.path)
            
            switch measurementSettings.measurmentMode {
            case .Raw:
                rawRadioButton.unselectAlternateButtons()
            case .Reflectance:
                reflectanceRadioButton.unselectAlternateButtons()
            case .Radiance:
                radianceRadioButton.unselectAlternateButtons()
            }
            
            validateInputFields()
            
        }
    }
    
    func openFileBrowser(path: URL?) {
        
        let directoryBrowserContainerViewController = self.storyboard!.instantiateViewController(withIdentifier: "DirectoryBrowserContainerViewController") as! DirectoryBrowserContainerViewController
        
        // initialize path if already exists
        if let existingPath = path {
            directoryBrowserContainerViewController.selectedPath = existingPath
        }
        
        let navigationController = UINavigationController(rootViewController: directoryBrowserContainerViewController)
        navigationController.modalPresentationStyle = .formSheet
        
        // Hook up the select event
        directoryBrowserContainerViewController.didSelectFile = {(file: DiskFile) -> Void in
            self.selectPathInput.update(diskFile: file.filePath)
        }
        
        present(navigationController, animated: true, completion: nil)
    }
    
    func didSelectPath() {
        validateInputFields()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateInputFields()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nextButton.isEnabled = false
    }
    
    // Hides the keyboard when the return button is clicked
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        validateInputFields()
        hideKeyboard()
        return false
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    func validateInputFields() -> Void {
        if ValidationManager.sharedInstance.validateSubViews(view: self.view) {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
    
    override func goToNextPage(){
        
        // first save settings to userDefaults
        let measurementMode = rawRadioButton.isSelected ? MeasurmentMode.Raw : reflectanceRadioButton.isSelected ? MeasurmentMode.Reflectance : radianceRadioButton.isSelected ? MeasurmentMode.Radiance : nil
        pageContainer!.measurmentMode = measurementMode
        let measurmentSettings = MeasurmentSettings(fileName: fileNameTextField.text!, path: selectPathInput.selectedPath!, measurmentMode: measurementMode!)
        
        let settingsData = NSKeyedArchiver.archivedData(withRootObject: measurmentSettings)
        UserDefaults.standard.set(settingsData, forKey: "MeasurmentSettings")
        UserDefaults.standard.synchronize()
        
        // append the next page
        switch measurementMode! {
        case MeasurmentMode.Raw:
            pageContainer!.pages.append(RawPage())
            break
        case MeasurmentMode.Radiance:
            pageContainer!.pages.append(RadiancePage())
            break
        case MeasurmentMode.Reflectance:
            pageContainer!.pages.append(ReflectancePage())
            break
        }
        
        // got to next page
        pageContainer?.goToNextPage()
    }

    
}
