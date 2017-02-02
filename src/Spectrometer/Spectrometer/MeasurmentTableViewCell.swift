//
//  FileBrowserTableViewCell.swift
//  Spectrometer
//
//  Created by raphi on 02.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit
import Zip

class MeasurmentTableViewCell : UITableViewCell {
    
    @IBOutlet var titelLabel: UILabel!
    @IBOutlet var myImageView: UIImageView!
    @IBOutlet var pathLabel: UILabel!
    
    var selectedFile: DiskFile? = nil
    var viewController: UIViewController? = nil
    
    @IBAction func export(_ sender: UIButton) {
        
        if let file = selectedFile {
            
            var fileToExport:URL = file.filePath
            
            // if a directory is selected create a zip to export
            if (file.isDirectory) {
                
                do {
                    let tempDirecotry:URL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(file.displayName + ".zip")
                    try Zip.zipFiles(paths: [fileToExport], zipFilePath: tempDirecotry, password: nil, progress: { (progress) -> () in
                        print(progress)
                    })
                    fileToExport = tempDirecotry
                    print("Temp Path: " + fileToExport.relativePath)
                }
                catch {
                    viewController?.showWarningMessage(title: "Fehler", message: "Der Ordner kann nicht exportiert werden.")
                }
            }
            
            let activityVC = UIActivityViewController(activityItems: [fileToExport], applicationActivities: nil)
            
            //New Excluded Activities Code
            activityVC.excludedActivityTypes = [UIActivityType.postToFacebook, UIActivityType.postToTwitter, UIActivityType.assignToContact, UIActivityType.addToReadingList, UIActivityType.openInIBooks, UIActivityType.saveToCameraRoll]
        
            
            activityVC.popoverPresentationController?.sourceView = sender as UIView
            activityVC.popoverPresentationController?.sourceRect = sender.bounds
            
            activityVC.popoverPresentationController?.canOverlapSourceViewRect = false
            activityVC.popoverPresentationController?.permittedArrowDirections = [UIPopoverArrowDirection.left]
            viewController?.present(activityVC, animated: true, completion: nil)
            
            activityVC.completionWithItemsHandler = { acivity, success, items, err in
                print("finished: " + success.description)
            }
                
            
        }
        
        
    }
    
    
    func finishedExport() -> Void {
        
        
        
    }
    
    
    func setInfo(selectedFile : DiskFile, viewController: UIViewController){
        
        titelLabel.text = selectedFile.displayName
        pathLabel.text = selectedFile.filePath.relativePath
        myImageView.image = selectedFile.image()
        self.viewController = viewController
        self.selectedFile = selectedFile
    
    }
    
}
