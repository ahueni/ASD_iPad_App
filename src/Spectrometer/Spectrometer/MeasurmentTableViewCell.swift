//
//  FileBrowserTableViewCell.swift
//  Spectrometer
//
//  Created by raphi on 02.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class MeasurmentTableViewCell : UITableViewCell {
    
    @IBOutlet var titelLabel: UILabel!
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var pathLabel: UILabel!
    
    var selectedFile: DiskFile? = nil
    var viewController: UIViewController? = nil
    
    @IBAction func export(_ sender: UIButton) {
        
        if let file = selectedFile {
            
            let exportItem = DiskFileActivityItem(selectedFile: file)
            let activityVC = UIActivityViewController(activityItems: [exportItem], applicationActivities: nil)
            
            // excluded activities like facebook, twitter etc.
            activityVC.excludedActivityTypes = [UIActivityType.postToFacebook, UIActivityType.postToTwitter, UIActivityType.assignToContact, UIActivityType.addToReadingList, UIActivityType.openInIBooks, UIActivityType.saveToCameraRoll]
            
            activityVC.popoverPresentationController?.sourceView = sender as UIView
            activityVC.popoverPresentationController?.sourceRect = sender.bounds
            
            activityVC.popoverPresentationController?.permittedArrowDirections = [UIPopoverArrowDirection.left]
            viewController?.present(activityVC, animated: true, completion: nil)
            
            // delete temp file if it was a directory
            activityVC.completionWithItemsHandler = { acivity, success, items, err in
                
                if (exportItem.file.isDirectory) {
                    do {
                        try FileManager.default.removeItem(at: exportItem.exportUrl)
                        print("-- DELETED TEMP FILE --")
                    } catch {
                        print("-- TEMP FILE COULD NOT BE DELETED --")
                    }
                }
                
            }
                
            
        }
        
        
    }
    
    // initialize table view cell with data
    func setInfo(selectedFile : DiskFile, viewController: UIViewController){
        titelLabel.text = selectedFile.displayName
        pathLabel.text = selectedFile.filePath.relativePath
        myImageView.image = selectedFile.image()
        self.viewController = viewController
        self.selectedFile = selectedFile
    }
    
}
