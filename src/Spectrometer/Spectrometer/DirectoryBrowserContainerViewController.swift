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
    @IBAction func AddDirectoryButtonClicked(_ sender: UIBarButtonItem) {
        self.containerViewController?.createFolder()
    }
    
    @IBAction func ChooseDirectoryButtonClicked(_ sender: UIBarButtonItem) {
        let selectedFolder = DiskFile(url: selectedPath == nil ? documentsURL() : selectedPath!)
        didSelectFile!(selectedFolder)
        dismiss(animated: true, completion: nil)
    }
    
    public func documentsURL() -> URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
    }

}
