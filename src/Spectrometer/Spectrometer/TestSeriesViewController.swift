//
//  TestSeriesViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 18.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit
import FileBrowser

class TestSeriesViewController : UITableViewController {
    
    var pageIndex: Int = 0
    var strTitle: String!
    var pageContainer : ParentViewController? = nil
    
    @IBOutlet weak var filePathTextField: UIButton!
    @IBOutlet weak var fileNameTextField: UITextField!
    @IBOutlet weak var whiteRefrenceSettingsSegmentControl: UISegmentedControl!
    @IBOutlet weak var measurementCountTextField: UITextField!
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        goToNextPage()
    }
    
    @IBAction func CancelButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func changeFilePathButtonClicked(_ sender: UIButton) {
        let fileBrowser = FileBrowser()
        present(fileBrowser, animated: true, completion: nil)
        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
            print (file.filePath)
            print ("Ordner: "+file.isDirectory.description)
            self.pageContainer?.measurmentSettings.path = file.filePath
            self.filePathTextField.titleLabel?.text = file.filePath.relativePath
        }
    }
    
    func goToNextPage(){
            pageContainer?.measurmentSettings.fileName = fileNameTextField.text!
            pageContainer?.measurmentSettings.measurementCount = Int(measurementCountTextField.text!)!
            switch whiteRefrenceSettingsSegmentControl.selectedSegmentIndex {
            case 0:
                pageContainer?.measurmentSettings.whiteRefrenceSetting = WhiteRefrenceSettings.TakeOnce
            default:
                pageContainer?.measurmentSettings.whiteRefrenceSetting = WhiteRefrenceSettings.TakeBeforeMesurement
            }
        
        pageContainer?.goToNextPage()
    }
    
}
