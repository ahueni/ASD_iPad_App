//
//  MeasurmentMasterTableViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 24.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import UIKit

class MeasurmentMasterTableViewController: BaseFileBrowserTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFile = getFileForIndexPath(indexPath: indexPath)
        
        if selectedFile.isDirectory {
            let measurmentMasterTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "MeasurmentMasterTableViewController") as! MeasurmentMasterTableViewController
            //setInitialPath is called cause init(initialpath) will not be called from storyboard
            measurmentMasterTableViewController.currentPath = selectedFile.filePath
            navigationController?.pushViewController(measurmentMasterTableViewController, animated: true)
        }
        else {
            let measurmentDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MeasurmentDetailViewController") as! MeasurmentDetailViewController
            
            measurmentDetailViewController.url = selectedFile.filePath
            showDetailViewController(measurmentDetailViewController, sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
