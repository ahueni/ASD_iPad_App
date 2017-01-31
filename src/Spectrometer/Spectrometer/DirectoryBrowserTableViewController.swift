//
//  DirectoryBrowserTableViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 31.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class DirectoryBrowserTableViewController: FileBrowserTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFile = getFileForIndexPath(indexPath: indexPath)
        if(selectedFile.isDirectory)
        {
            let directoryBrowserContainerViewController = self.storyboard?.instantiateViewController(withIdentifier: "DirectoryBrowserContainerViewController") as! DirectoryBrowserContainerViewController
            //setInitialPath is called cause init(initialpath) will not be called from storyboard
            directoryBrowserContainerViewController.selectedPath = selectedFile.filePath
            directoryBrowserContainerViewController.didSelectFile = didSelectFile
            navigationController!.pushViewController(directoryBrowserContainerViewController, animated: true)
        }
        else
        {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
