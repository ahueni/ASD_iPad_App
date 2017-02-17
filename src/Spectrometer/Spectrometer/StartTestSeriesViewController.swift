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
    
    @IBOutlet weak var fileNameTextField: UITextField!
    @IBOutlet var selectPathInput: SelectInputPath!
    
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var StartButton: UIButton!
    
    @IBOutlet weak var RawRadioButton: RadioButton!
    @IBOutlet weak var RadianceRadioButton: RadioButton!
    @IBOutlet weak var ReflectanceRadioButton: RadioButton!
    
    var selectedPath : URL? = nil
    
    func selectPath() -> DiskFile {
        
        let directoryBrowserContainerViewController = self.storyboard!.instantiateViewController(withIdentifier: "DirectoryBrowserContainerViewController") as! DirectoryBrowserContainerViewController
        
        let navigationController = UINavigationController(rootViewController: directoryBrowserContainerViewController)
        navigationController.modalPresentationStyle = .formSheet
        
        var blubber:DiskFile!
        
        // Hook up the select event
        directoryBrowserContainerViewController.didSelectFile = {(file: DiskFile) -> Void in
            blubber = file
            self.selectedPath = file.filePath
        }
        
        present(navigationController, animated: true, completion: nil)
        
        return blubber
    }
    
    override func viewDidLoad() {
        fileNameTextField.delegate = self;
        
        selectPathInput.selectPathDelegate = self
        
        RawRadioButton?.alternateButton = [RadianceRadioButton, ReflectanceRadioButton]
        RadianceRadioButton?.alternateButton = [RawRadioButton, ReflectanceRadioButton]
        ReflectanceRadioButton?.alternateButton = [RawRadioButton!, RadianceRadioButton]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        loadSettingsIfExist()
    }
    
    func loadSettingsIfExist(){
        let measurmentSettings = UserDefaults.standard.data(forKey: "MeasurmentSettings")
        if(measurmentSettings != nil){
            let loadedSettings = NSKeyedUnarchiver.unarchiveObject(with: measurmentSettings!) as! MeasurmentSettings
            print("settings loaded")
        }
    }

    
    override func awakeFromNib() {
        self.view.layoutIfNeeded()
        
        RawRadioButton.isSelected = true
        RadianceRadioButton.isSelected = false
        ReflectanceRadioButton.isSelected = false
    }
    
    @IBAction func NameTextFieldEditingChanged(_ sender: Any) {
        validate()
    }
    
    @IBAction func measurmentCountTextFieldEditingChanged(_ sender: Any) {
        validate()
    }
    
    func validate()
    {
        //StartButton.isEnabled = ValidationManager.sharedInstance.validateSubViews(view: view)
    }
    
    // Hides the keyboard when the return button is clicked
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    override func goToNextPage(){
        let measurementMode = RawRadioButton.isSelected ? MeasurmentMode.Raw : ReflectanceRadioButton.isSelected ? MeasurmentMode.Reflectance : RadianceRadioButton.isSelected ? MeasurmentMode.Radiance : nil
        pageContainer!.measurmentMode = measurementMode
        let measurmentSettings = MeasurmentSettings(fileName: fileNameTextField.text!, path: selectedPath!, measurmentMode: measurementMode!)
        
        let settingsData = NSKeyedArchiver.archivedData(withRootObject: measurmentSettings)
        UserDefaults.standard.set(settingsData, forKey: "MeasurmentSettings")
        UserDefaults.standard.synchronize()
        
        print("settings saved")
        
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
