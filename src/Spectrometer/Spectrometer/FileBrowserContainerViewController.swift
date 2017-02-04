//
//  FileBrowserContainerViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 31.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class FileBrowserContainerViewController : UIViewController{    
    
    let inboxPath:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("Inbox", isDirectory: true)
    
    // this vc is embeded with a container view
    var containerViewController: FileBrowserTableViewController?
    let containerFileSegueName = "FileBrowserTableViewControllerSegue"
    let containerDirectorrySegueName = "DirectoryBrowserTableViewControllerSegue"
    
    let fileManager = FileManager.default
    
    var selectedPath:URL
    
    required init?(coder aDecoder: NSCoder) {
        selectedPath = inboxPath
        super.init(coder: aDecoder)
    }
    
    
    open var didSelectFile: ((DiskFile) -> ())? {
        didSet {
            containerViewController?.didSelectFile = didSelectFile
        }
    }
    
    // prepare is called before viewDidLoad => set the embeded vc variable
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == containerFileSegueName {
            containerViewController = segue.destination as? FileBrowserTableViewController
            containerViewController?.initializeTableData(startFolder: selectedPath)
        }
        
        if segue.identifier == containerDirectorrySegueName {
            containerViewController = segue.destination as! DirectoryBrowserTableViewController
            containerViewController!.initializeTableData(startFolder: selectedPath)
        }
        
        containerViewController!.didSelectFile = didSelectFile
        title = selectedPath.lastPathComponent
    }
    
    override func viewDidLoad() {
        // Add dismiss button
        let dismissButton = UIBarButtonItem(title: "Abbrechen", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelClicked(sender:)))
        self.navigationItem.rightBarButtonItem = dismissButton
    }
    
    func cancelClicked(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
