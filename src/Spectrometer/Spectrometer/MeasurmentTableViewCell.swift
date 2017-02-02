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
        let textToShare = "Swift is awesome!  Check out this website about it!"
        
        if selectedFile?.filePath != nil {
            let objectsToShare = [textToShare, selectedFile?.filePath] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityType.postToFacebook, UIActivityType.postToTwitter, UIActivityType.assignToContact, UIActivityType.addToReadingList, UIActivityType.openInIBooks, UIActivityType.saveToCameraRoll]
        
            
            activityVC.popoverPresentationController?.sourceView = sender
            viewController?.present(activityVC, animated: true, completion: nil)
        }
        
        
    }
    
    func setInfo(selectedFile : DiskFile, viewController: UIViewController){
        
        titelLabel.text = selectedFile.displayName
        pathLabel.text = selectedFile.filePath.relativePath
        myImageView.image = selectedFile.image()
        self.viewController = viewController
        self.selectedFile = selectedFile
    
    }
    
}
