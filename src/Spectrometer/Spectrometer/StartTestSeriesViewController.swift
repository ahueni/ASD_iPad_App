//
//  TestSeriesViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 18.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class StartTestSeriesViewController : BaseMeasurementModal, UITextFieldDelegate {
    
    @IBOutlet weak var fileNameTextField: UITextField!
    
    @IBOutlet weak var filePathButton: UIButton!
    
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var StartButton: UIButton!
    
    @IBOutlet weak var RawRadioButton: RadioButton!
    @IBOutlet weak var RadianceRadioButton: RadioButton!
    @IBOutlet weak var ReflectanceRadioButton: RadioButton!
    
    var selectedPath : URL? = nil
    
    override func viewDidLoad() {
        fileNameTextField.delegate = self;
        
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
    
    @IBAction func changeFilePathButtonClicked(_ sender: UIButton) {
        
        let directoryBrowserContainerViewController = self.storyboard!.instantiateViewController(withIdentifier: "DirectoryBrowserContainerViewController") as! DirectoryBrowserContainerViewController
        
        let navigationController = UINavigationController(rootViewController: directoryBrowserContainerViewController)
        navigationController.modalPresentationStyle = .formSheet
        
        // Hook up the select event
        directoryBrowserContainerViewController.didSelectFile = {(file: DiskFile) -> Void in
            self.selectedPath = file.filePath
            self.filePathButton.setTitle(file.filePath.lastPathComponent, for: .normal)
        }
        
        present(navigationController, animated: true, completion: nil)
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
