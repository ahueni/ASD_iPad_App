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
    
    let ceruleanColor = UIColor(red:0.00, green:0.61, blue:0.92, alpha:1.00)
    
    @IBOutlet var titelLabel: UILabel!
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var pathLabel: UILabel!
    @IBOutlet var exportButton: UIButton! {
        didSet {
            let exportImage = UIImage.fontAwesomeIcon(name: .shareAlt, textColor: ceruleanColor, size: CGSize(width: 25, height: 25))
            exportButton.setImage(exportImage, for: .normal)
            exportButton.imageView?.center = exportButton.center
        }
    }
    
    // store file and viewcontroller to present export popover
    var selectedFile: DiskFile!
    var viewController: UIViewController!
    
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
                
                // when file was exportet, delete it when created a zip from directory
                if (exportItem.file.isDirectory && success) {
                    do {
                        try FileManager.default.removeItem(at: exportItem.exportUrl)
                    } catch {
                    }
                }
                
            }
                
            
        }
        
        
    }
    
}
