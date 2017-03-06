//
//  FileBrowserWithButtonsContainerViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 31.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class DirectoryBrowserContainerViewController : FileBrowserContainerViewController
{
    let measurementPath:URL = InstrumentStore.sharedInstance.measurementsRoot
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.selectedPath = measurementPath
    }
    
    @IBAction func AddDirectoryButtonClicked(_ sender: UIBarButtonItem) {
        self.containerViewController?.createFolder()
    }
    
    @IBAction func ChooseDirectoryButtonClicked(_ sender: UIBarButtonItem) {
        didSelectFile!(DiskFile(url: selectedPath))
        dismiss(animated: true, completion: nil)
    }

}
