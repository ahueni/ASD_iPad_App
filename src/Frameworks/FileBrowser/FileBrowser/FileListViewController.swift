//
//  FileListViewController.swift
//  FileBrowser
//
//  Created by Roy Marmelstein on 12/02/2016.
//  Copyright © 2016 Roy Marmelstein. All rights reserved.
//

import Foundation

class FileListViewController: UIViewController {
    
    // TableView
    @IBOutlet weak var tableView: UITableView!
    
    let collation = UILocalizedIndexedCollation.current()
    
    /// Data
    var didSelectFile: ((FBFile) -> ())?
    var files = [FBFile]()
    var initialPath: URL?
    let previewManager = PreviewManager()
    var sections: [[FBFile]] = []

    // Search controller
    var filteredFiles = [FBFile]()
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.backgroundColor = UIColor.white
        searchController.dimsBackgroundDuringPresentation = true
        return searchController
    }()
    
    
    //MARK: Lifecycle
    
    convenience init (initialPath: URL) {
        self.init(nibName: "FileBrowser", bundle: Bundle(for: FileListViewController.self))
        self.edgesForExtendedLayout = UIRectEdge()
        
        // Set initial path
        self.initialPath = initialPath
        self.title = initialPath.lastPathComponent
        
        // Set search controller delegates
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
        
        // Add dismiss button
        let dismissButton = UIBarButtonItem(title: "Abbrechen", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FileListViewController.dismiss(button:)))
        self.navigationItem.rightBarButtonItem = dismissButton
        
        currentPath = initialPath
    }
    
    deinit{
        if #available(iOS 9.0, *) {
            searchController.loadViewIfNeeded()
        } else {
            searchController.loadView()
        }
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        
        if parent == nil{
            currentPath?.deleteLastPathComponent()
            print(currentPath?.absoluteString)
            
        }
    }
    
    //MARK: UIViewController
    
    override func viewDidLoad() {
        
        let buttonIndex = self.view.subviews.index{ $0 is UIButton }
        let addFolderButton = self.view.subviews[buttonIndex!] as! UIButton
        addFolderButton.addTarget(self, action: #selector(buttonAddFolderAction), for: .touchUpInside)
        
        let buttonChooseIndex = self.view.subviews.reversed().index{ $0 is UIButton }
        let chooseButton = self.view.subviews.reversed()[buttonChooseIndex!] as! UIButton
        chooseButton.addTarget(self, action: #selector(buttonChooseAction), for: .touchUpInside)
        
        // Prepare data
        if let initialPath = initialPath {
            files = parser.filesForDirectory(initialPath)
            indexFiles()
        }
        
        // Set search bar
        tableView.tableHeaderView = searchController.searchBar
        
        // Register for 3D touch
        self.registerFor3DTouch()
    }
    
    func buttonChooseAction(sender: UIButton!){
        let selectedFolder = FBFile(filePath: (currentPath?.absoluteURL)!)
        didSelectFile!(selectedFolder)
        self.dismiss()
    }
    
    func buttonAddFolderAction(sender: UIButton!) {
        print("Add Folder: ")
        print(currentPath?.absoluteString)
        
        let alert = UIAlertController(title: "Neuer Ordner", message: "Wie soll der Ordner heissen?", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Ordner Name"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            if(textField?.text == "" || self.files.filter({$0.displayName == textField?.text}).count > 0){
                let error = UIAlertController(title: "Fehler", message: "Ordnername ist nicht korrekt oder es gibt bereits einen Ordner mit diesem Namen", preferredStyle: .alert)
                error.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(error, animated: true, completion: nil)
            }
            
            do{
                let createFolderPath = currentPath?.appendingPathComponent(textField!.text!)
                try parser.fileManager.createDirectory(atPath: (createFolderPath?.relativePath)!, withIntermediateDirectories: false, attributes: nil)
                self.files = parser.filesForDirectory(currentPath!)
                self.indexFiles()
                DispatchQueue.main.async{
                    self.tableView.reloadData()
                }
                
            }
            catch _
            {
                let error = UIAlertController(title: "Fehler", message: "Der Ordner konnte nicht erstellt werden", preferredStyle: .alert)
                error.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(error, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Scroll to hide search bar
        self.tableView.contentOffset = CGPoint(x: 0, y: searchController.searchBar.frame.size.height)
        
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
        var file: FBFile
        if searchController.isActive {
            file = filteredFiles[(indexPath as NSIndexPath).row]
        }
        else {
            file = sections[(indexPath as NSIndexPath).section][(indexPath as NSIndexPath).row]
        }
        return file
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredFiles = files.filter({ (file: FBFile) -> Bool in
            return file.displayName.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }

}

