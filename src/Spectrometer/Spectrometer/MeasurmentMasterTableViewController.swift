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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // initialize start folder
        print("-- INSTANTIATE MEASUREMENT TABLE VIEW CONTROLLER --")
        let initFolder = InstrumentSettingsCache.sharedInstance.measurementsRoot
        self.initializeTableData(startFolder: initFolder)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFile = getFileForIndexPath(indexPath: indexPath)
        
        if selectedFile.isDirectory {
            let measurmentMasterTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "MeasurmentMasterTableViewController") as! MeasurmentMasterTableViewController
            
            measurmentMasterTableViewController.initializeTableData(startFolder: selectedFile.filePath)
            
            navigationController?.pushViewController(measurmentMasterTableViewController, animated: true)
        }
        else {
            let measurmentDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MeasurmentDetailViewController") as! MeasurmentDetailViewController
            
            measurmentDetailViewController.url = selectedFile.filePath
            measurmentDetailViewController.title = selectedFile.filePath.lastPathComponent
            
            showDetailViewController(measurmentDetailViewController, sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MeasurmentTableViewCell", for: indexPath) as! MeasurmentTableViewCell
        
        let selectedFile = getFileForIndexPath(indexPath: indexPath)
        
        cell.viewController = self
        cell.selectedFile = selectedFile
        
        cell.titelLabel.text = selectedFile.displayName
        
        // show the last 3 path components
        let pathComponents = selectedFile.filePath.pathComponents
        cell.pathLabel.text = pathComponents[pathComponents.count-3...pathComponents.count-1].joined(separator: "/")

        let newImageSize = CGSize(width: 40, height: 40)
        let ceruleanColor = UIColor(red:0.00, green:0.61, blue:0.92, alpha:1.00)
        cell.myImageView.image = selectedFile.image(size: newImageSize, color: ceruleanColor)
        
        return cell
        
    }

    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
            
            let file:DiskFile = self.getFileForIndexPath(indexPath: indexPath)
            
            do {
                try FileManager.default.removeItem(at: file.filePath)
            } catch {
                self.showWarningMessage(title: "Error", message: file.displayName + " could not be deleted.")
            }
            
            // update table data and then delete the row
            self.updateTableData()
            self.tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
            
        });
        
        return [deleteRowAction];
        
        
    }
    
    @IBAction func toggleEditingItem(_ sender: UIBarButtonItem) {
        self.setEditing(!self.isEditing, animated: true)
        if self.isEditing {
            sender.title = "Finish"
        } else {
            sender.title = "Edit"
        }
        
    }
    
    @IBAction func newFolderClicked(_ sender: UIBarButtonItem) {
        self.createFolder()
    }
    
    
    
}
