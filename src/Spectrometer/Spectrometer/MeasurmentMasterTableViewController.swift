//
//  MeasurmentMasterTableViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 24.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import UIKit
import FileBrowser

class MeasurmentMasterTableViewController: UITableViewController {
    
    let parser = FileParser.sharedInstance
    var currentPath : URL? = nil
    let collation = UILocalizedIndexedCollation.current()
    
    /// Data
    var didSelectFile: ((FBFile) -> ())?
    var files = [FBFile]()
    var initialPath: URL?
    var sections: [[FBFile]] = []
    
    //MARK: Lifecycle
    convenience init (initialPath: URL) {
        self.init(nibName: nil, bundle: Bundle.main)
        self.edgesForExtendedLayout = UIRectEdge()
        setInitialPath(initialPath: initialPath)
    }
    
    func setInitialPath(initialPath: URL){
        self.initialPath = initialPath
        self.title = initialPath.lastPathComponent
        currentPath = initialPath
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Prepare data
        if let initialPath = initialPath {
            files = parser.filesForDirectory(initialPath)
            indexFiles()
        }
        else{
            initialPath = parser.documentsURL()
            files = parser.filesForDirectory(initialPath!)
            indexFiles()
        }
        
        // Make sure navigation bar is visible
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc func dismiss(button: UIBarButtonItem = UIBarButtonItem()) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Data
    
    func indexFiles() {
        let selector: Selector = #selector(getter: UIPrinter.displayName)
        sections = Array(repeating: [], count: collation.sectionTitles.count)
        if let sortedObjects = collation.sortedArray(from: files, collationStringSelector: selector) as? [FBFile]{
            for object in sortedObjects {
                let sectionNumber = collation.section(for: object, collationStringSelector: selector)
                sections[sectionNumber].append(object)
            }
        }
    }
    
    func fileForIndexPath(_ indexPath: IndexPath) -> FBFile {
        let file = sections[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        return file
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FileCell"
        var cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = reuseCell
        }
        cell.selectionStyle = .blue
        let selectedFile = fileForIndexPath(indexPath)
        cell.textLabel?.font = UIFont(name: "Open Sans", size: 30)
        cell.textLabel?.text = selectedFile.displayName
        cell.imageView?.image = selectedFile.type.image()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedFile = fileForIndexPath(indexPath)
        currentPath = selectedFile.filePath
        if selectedFile.isDirectory {
            let measurmentMasterTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "MeasurmentMasterTableViewController") as! MeasurmentMasterTableViewController
            //setInitialPath is called cause init(initialpath) will not be called from storyboard
            measurmentMasterTableViewController.setInitialPath(initialPath: selectedFile.filePath)
            navigationController?.pushViewController(measurmentMasterTableViewController, animated: true)
        }
        else {
            let measurmentDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "MeasurmentDetailViewController") as! MeasurmentDetailViewController
            
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let file = fileForIndexPath(indexPath)
                measurmentDetailViewController.url = file.filePath
            }
            showDetailViewController(measurmentDetailViewController, sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sections[section].count > 0 {
            return collation.sectionTitles[section]
        }
        else {
            return nil
        }
    }

}
