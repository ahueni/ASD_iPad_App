//
//  DiskFileActivityItem.swift
//  Spectrometer
//
//  Created by raphi on 03.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import Zip

class DiskFileActivityItem: UIActivityItemProvider {
    
    let file:DiskFile
    var exportUrl:URL
    
    init(selectedFile: DiskFile) {
        file = selectedFile
        exportUrl = selectedFile.filePath
        super.init(placeholderItem: NSData())
    }
    
    // this mehtod is only used to check the export file type it should be the same as the exported file
    // will be called when first open the export popup
    override func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return exportUrl
    }
    
    // will only be called when a export provider is selected by user
    override func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivityType) -> Any? {
        
        // if url is directory create a zip to export
        if (file.isDirectory) {
            
            do {
                let tempDirecotry:URL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(file.displayName + ".zip")
                try Zip.zipFiles(paths: [file.filePath], zipFilePath: tempDirecotry, password: nil, progress: nil)
                exportUrl = tempDirecotry
            }
            catch { /* export file without zip when zipping not working -> this is a default behavior no more action is needed here */ }
            
        }
        
        return exportUrl
        
    }
    
    
}
