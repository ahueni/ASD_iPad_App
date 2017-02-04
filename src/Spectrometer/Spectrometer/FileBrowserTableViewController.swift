//
//  FileBrowserTableViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 31.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class FileBrowserTableViewController: BaseFileBrowserTableViewController {
    
    var didSelectFile: ((DiskFile) -> ())?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedFile = getFileForIndexPath(indexPath: indexPath)
        
        if(selectedFile.isDirectory)
        {
            let fileBrowserContainerViewController = self.storyboard?.instantiateViewController(withIdentifier: "FileBrowserContainerViewController") as! FileBrowserContainerViewController
            //setInitialPath is called cause init(initialpath) will not be called from storyboard
            fileBrowserContainerViewController.selectedPath = selectedFile.filePath
            fileBrowserContainerViewController.didSelectFile = didSelectFile
            navigationController!.pushViewController(fileBrowserContainerViewController, animated: true)
        }
        else
        {
            didSelectFile!(selectedFile)
            dismiss(animated: true, completion: nil)
        }
    }
}
