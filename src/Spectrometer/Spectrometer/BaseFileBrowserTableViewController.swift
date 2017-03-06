//
//  BaseFileBrowserTableViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 30.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import FontAwesome_swift
import Foundation
import UIKit

class BaseFileBrowserTableViewController : UITableViewController {
    
    var diskFiles = [DiskFile]()
    let fileManager = FileManager.default
    let measurementPath:URL = InstrumentStore.sharedInstance.measurementsRoot
    
    var currentPath:URL
    
    required init?(coder aDecoder: NSCoder) {
        currentPath = measurementPath
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Make sure navigation bar is visible
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateTableData()
        self.tableView.reloadData()
        print("-- RELOADED TABLE DATA -- ")
    }
    
    func initializeTableData(startFolder: URL) {
        // set path for table data
        currentPath = startFolder
        self.title = startFolder.lastPathComponent
        // load data to model
        diskFiles = getAllDiskFiles(url: currentPath)
    }
    
    func getAllDiskFiles(url: URL) -> [DiskFile]
    {
        var files = [DiskFile]()
        var filePaths : [URL]
        do{
            filePaths = try self.fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: [], options: [.skipsHiddenFiles])
        } catch _{
            return files
        }
        for filePath in filePaths{
            files.append(DiskFile(url: filePath.absoluteURL))
        }
        
        return files
    }
    
    func getDictionaries() -> [DiskFile]{
        return diskFiles.filter{$0.isDirectory == true}
    }
    
    func getFiles() -> [DiskFile]{
        return diskFiles.filter{$0.isDirectory == false}
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Count of Filetypes => Currently Files or Folders => 2
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return getDictionaries().count
        }
        return getFiles().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "FileCell"
        var cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = reuseCell
        }
        
        cell.selectionStyle = .blue
        let selectedFile = getFileForIndexPath(indexPath: indexPath)
        cell.textLabel?.font = UIFont.defaultFontRegular(size: 16)
        cell.textLabel?.text = selectedFile.displayName
        
        // take cell heigt to calculate image size
        if let imageView = cell.imageView {
            
            let imageSize = CGSize(width: 24, height: 24)
            let ceruleanColor = UIColor(red:0.00, green:0.61, blue:0.92, alpha:1.00)
            imageView.image = selectedFile.image(size: imageSize, color: ceruleanColor)
            
        }
        
        return cell
    }
    
    func getFileForIndexPath(indexPath : IndexPath) -> DiskFile
    {
        var files = indexPath.section == 1 ? getFiles() : getDictionaries()
        return files[indexPath.row]
    }
    
    func insertDiskFile(url : URL)
    {
        let newDirectoryDiskFile = DiskFile(url: url)
        diskFiles.insert(newDirectoryDiskFile, at: diskFiles.count)
        tableView!.beginUpdates()
        let index = diskFiles.filter{$0.isDirectory}.count-1
        tableView!.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        tableView!.endUpdates()
    }
    
    func updateTableData() {
        diskFiles = getAllDiskFiles(url: currentPath)
        diskFiles.sort() { $0.displayName < $1.displayName }
    }
    
    weak var createFolderAction:UIAlertAction?
    
    internal func createFolder() {
        
        let alert = UIAlertController(title: "New Folder", message: "Please enter a foldername.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Foldername"
            textField.clearButtonMode = .whileEditing
            textField.addTarget(self, action: #selector(self.validateFolderPath(_:)), for: .editingChanged)
        }
        
        createFolderAction = UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
            
            let newFolderString:String = (alert?.textFields![0].text)! // Force unwrapping because we know it exists.
            
            do{
                let createFolderPath = self.currentPath.appendingPathComponent(newFolderString)
                try self.fileManager.createDirectory(atPath: createFolderPath.path, withIntermediateDirectories: false, attributes: nil)
                self.insertDiskFile(url: createFolderPath)
            }
            catch _
            {
                let error = UIAlertController(title: "Error", message: "The folder could not be created", preferredStyle: .alert)
                error.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(error, animated: true, completion: nil)
            }
            
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        createFolderAction?.isEnabled = false
        alert.addAction(createFolderAction!)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func validateFolderPath(_ sender: UITextView) {
        
        let newFolderString = sender.text!
        
        // check for correct folder name
        // TODO: add a check for illegal folder characters -> ":","/"
        if(newFolderString == ""){
            createFolderAction!.isEnabled = false
        } else if (self.diskFiles.filter({$0.displayName == newFolderString}).count > 0) {
            createFolderAction!.isEnabled = false
        } else if (newFolderString[newFolderString.startIndex] == " ") {
            createFolderAction!.isEnabled = false
        }
        
        createFolderAction!.isEnabled = true
        
    }
    
}


class DiskFile{
    
    let displayName: String
    let isDirectory: Bool
    let fileType : DiskFileType
    let filePath : URL
    
    init(url : URL)
    {
        displayName = url.lastPathComponent
        var isDir: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir)
        isDirectory = isDir.boolValue
        fileType = isDir.boolValue ? .Directory : .Default
        filePath = url.resolvingSymlinksInPath()
    }
    
    enum DiskFileType: String {
        /// Directory
        case Directory = "directory"
        /// GIF file
        case GIF = "gif"
        /// JPG file
        case JPG = "jpg"
        /// PLIST file
        case JSON = "json"
        /// PDF file
        case PDF = "pdf"
        /// PLIST file
        case PLIST = "plist"
        /// PNG file
        case PNG = "png"
        /// ZIP file
        case ZIP = "zip"
        /// Any file
        case Default = "file"
    }
    
    public func image(size: CGSize, color: UIColor) -> UIImage {
        
        switch fileType {
        case .Directory:
            return UIImage.fontAwesomeIcon(name: .folderO, textColor: color, size: size)
        case .JPG, .PNG, .GIF:
            return UIImage.fontAwesomeIcon(name: .fileImageO, textColor: color, size: size)
        case .PDF:
            return UIImage.fontAwesomeIcon(name: .filePdfO, textColor: color, size: size)
        case .ZIP:
            return UIImage.fontAwesomeIcon(name: .fileZipO, textColor: color, size: size)
        default:
            return UIImage.fontAwesomeIcon(name: .fileO, textColor: color, size: size)
        }
        
    }
}
