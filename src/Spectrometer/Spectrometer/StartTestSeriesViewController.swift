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
    
    @IBOutlet var rawRadioButton: RadioButton!
    @IBOutlet var reflectanceRadioButton: RadioButton!
    @IBOutlet var radianceRadioButton: RadioButton!
    
    var selectedPath : URL? = nil
    
    func selectPath() {
        
        let directoryBrowserContainerViewController = self.storyboard!.instantiateViewController(withIdentifier: "DirectoryBrowserContainerViewController") as! DirectoryBrowserContainerViewController
        
        // initialize path if already exists
        if let path = selectedPath {
            directoryBrowserContainerViewController.selectedPath = path
        }
        
        
        let navigationController = UINavigationController(rootViewController: directoryBrowserContainerViewController)
        navigationController.modalPresentationStyle = .formSheet
        
        // Hook up the select event
        directoryBrowserContainerViewController.didSelectFile = {(file: DiskFile) -> Void in
            self.selectedPath = file.filePath
            self.selectPathInput.update(selectedPath: file)
        }
        
        present(navigationController, animated: true, completion: nil)
    }
    
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
        
        // initialize last setting values
        loadSettingsIfExist()
    }
    
    func loadSettingsIfExist(){
        let measurmentSettings = UserDefaults.standard.data(forKey: "MeasurmentSettings")
        if(measurmentSettings != nil){
            let loadedSettings = NSKeyedUnarchiver.unarchiveObject(with: measurmentSettings!) as! MeasurmentSettings
            print("settings loaded")
        }
    }
    
    // Hides the keyboard when the return button is clicked
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    
    override func goToNextPage(){
        let measurementMode = rawRadioButton.isSelected ? MeasurmentMode.Raw : reflectanceRadioButton.isSelected ? MeasurmentMode.Reflectance : radianceRadioButton.isSelected ? MeasurmentMode.Radiance : nil
        pageContainer!.measurmentMode = measurementMode
        let measurmentSettings = MeasurmentSettings(fileName: fileNameTextField.text!, path: selectedPath!, measurmentMode: measurementMode!)
        
        let settingsData = NSKeyedArchiver.archivedData(withRootObject: measurmentSettings)
        UserDefaults.standard.set(settingsData, forKey: "MeasurmentSettings")
        UserDefaults.standard.synchronize()
        
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
        pageContainer?.goToNextPage()
    }

    
}
