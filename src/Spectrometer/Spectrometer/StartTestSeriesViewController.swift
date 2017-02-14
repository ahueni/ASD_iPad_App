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
        /*
        var whiteRefrenceSettings :WhiteRefrenceSettings?
        switch containerViewController!.whiteRefrenceSettingsSegmentControl.selectedSegmentIndex {
        case 0:
            whiteRefrenceSettings = WhiteRefrenceSettings.TakeBefore
        case 1:
            whiteRefrenceSettings = WhiteRefrenceSettings.TakeBeforeAndAfter
        case 2:
            whiteRefrenceSettings = WhiteRefrenceSettings.TakeAfter
        default:
            whiteRefrenceSettings = WhiteRefrenceSettings.TakeBeforeAndAfter
        }
        
        //save measurmentCount to config
        let measurmentCount = Int32(containerViewController!.MeasurmentCountStepper.value)
        appDelegate.config?.measurmentCount = measurmentCount
        appDelegate.saveContext()
        
        pageContainer!.measurmentSettings = MeasurmentSettings(measurementCount: Int(measurmentCount), whiteRefrenceSetting: whiteRefrenceSettings!, path: selectedPath!, fileName: (containerViewController?.fileNameTextField.text)!)
        
        pageContainer?.goToNextPage()
 */
    }

    
}
