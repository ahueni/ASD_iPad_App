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
    // this vc is embeded with a container view
    var containerViewController: FileBrowserTableViewController?
    let containerFileSegueName = "FileBrowserTableViewControllerSegue"
    let containerDirectorrySegueName = "DirectoryBrowserTableViewControllerSegue"
    
    var selectedPath : URL?
    let fileManager = FileManager.default
    
    open var didSelectFile: ((DiskFile) -> ())? {
        didSet {
            containerViewController?.didSelectFile = didSelectFile
        }
    }
    
    // prepare is called before viewDidLoad => set the embeded vc variable
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == containerFileSegueName {
            containerViewController = segue.destination as? FileBrowserTableViewController
        }
        
        if segue.identifier == containerDirectorrySegueName {
            containerViewController = segue.destination as! DirectoryBrowserTableViewController
        }
        
        containerViewController!.currentPath = selectedPath
        containerViewController!.didSelectFile = didSelectFile
        title = selectedPath == nil ? "Dokumente" : selectedPath!.lastPathComponent
    }
    
    func cancelClicked(sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        // Add dismiss button
        let dismissButton = UIBarButtonItem(title: "Abbrechen", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelClicked(sender:)))
        self.navigationItem.rightBarButtonItem = dismissButton
    }
}
