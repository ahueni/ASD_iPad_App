//
//  MeasurmentMasterTableViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 24.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import UIKit

class MeasurmentMasterTableViewController: BaseFileBrowserTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create own cell
        self.tableView.register(UINib(nibName: "MeasurmentTableViewCell", bundle: nil), forCellReuseIdentifier: "MeasurmentTableViewCell")
        
    }
    
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeasurmentTableViewCell", for: indexPath) as! MeasurmentTableViewCell
        let selectedFile = getFileForIndexPath(indexPath: indexPath)
        cell.setInfo(selectedFile: selectedFile, viewController: self)
        
        return cell
        
    }

    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Löschen", handler:{action, indexpath in
            
            let file:DiskFile = self.getFileForIndexPath(indexPath: indexPath)
            
            do {
                try FileManager.default.removeItem(at: file.filePath)
            } catch {
                self.showWarningMessage(title: "Fehler", message: file.displayName + " konnte nicht gelöscht werden.")
            }
            
            // update table data and then delete the row
            self.updateTableData()
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
        });
        
        return [deleteRowAction];
        
        
    }
    
    @IBAction func moreItemClicked(_ sender: UIBarButtonItem) {
        
        let tableViewController = UITableViewController()
        
        
    }
    
}
