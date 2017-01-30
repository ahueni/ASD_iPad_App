//
//  StartTestSeriesViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 27.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit
import FileBrowser

class StartTestSeriesViewController : BaseMeasurementModal{
    
    // this vc is embeded with a container view
    var containerViewController: TestSeriesViewController?
    let containerSegueName = "StartTestSeriesTableViewSegue"
    var selectedPath : URL? = nil
    
    override func viewDidLoad() {
        containerViewController!.StartButton.addTarget(self, action:#selector(self.nextButtonClicked(_:)), for: .touchUpInside)
        containerViewController!.CancelButton.addTarget(self, action:#selector(self.CancelButtonClicked(_:)), for: .touchUpInside)
        containerViewController!.filePathButton.addTarget(self, action:#selector(self.changeFilePathButtonClicked(_:)), for: .touchUpInside)
    }
    
    // prepare is called before viewDidLoad => set the embeded vc variable
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == containerSegueName {
            containerViewController = segue.destination as! TestSeriesViewController
            containerViewController!.pageContainer = pageContainer
        }
    }
    
    @IBAction func changeFilePathButtonClicked(_ sender: UIButton) {
        let fileBrowser = FileBrowser()
        present(fileBrowser, animated: true, completion: nil)
        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
            print (file.filePath)
            print ("Ordner: "+file.isDirectory.description)
            self.selectedPath = file.filePath
            self.containerViewController!.filePathButton.setTitle(file.filePath.relativePath, for: .normal)
        }
    }
    
    override func goToNextPage(){
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
        pageContainer!.measurmentSettings = MeasurmentSettings(measurementCount: Int(containerViewController!.measurementCountTextField.text!)!, whiteRefrenceSetting: whiteRefrenceSettings!, path: selectedPath!, fileName: (containerViewController?.fileNameTextField.text)!)
        
        pageContainer?.goToNextPage()
    }
}
