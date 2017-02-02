//
//  BaseFileBrowserTableViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 30.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class BaseFileBrowserTableViewController : UITableViewController{
    var diskFiles = [DiskFile]()
    var currentPath : URL?
    let fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Prepare data
        diskFiles = getAllDiskFiles(url: currentPath == nil ? documentsURL() : currentPath!)
        
        // Make sure navigation bar is visible
        self.navigationController?.isNavigationBarHidden = false
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
    
    public func documentsURL() -> URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Count of Filetypes => Currently Files or Folders => 2
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return getFiles().count
        }
        return getDictionaries().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FileCell"
        var cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = reuseCell
        }
        cell.selectionStyle = .blue
        let selectedFile = getFileForIndexPath(indexPath: indexPath)
        cell.textLabel?.font = UIFont(name: "Open Sans", size: 18)
        cell.textLabel?.text = selectedFile.displayName
        cell.imageView?.image = selectedFile.image()
        return cell
    }
    
    func getFileForIndexPath(indexPath : IndexPath) -> DiskFile
    {
        var files = indexPath.section == 0 ? getFiles() : getDictionaries()
        return files[indexPath.row]
    }
    
    func insertDiskFile(url : URL)
    {
        let newDirectoryDiskFile = DiskFile(url: url)
        diskFiles.insert(newDirectoryDiskFile, at: diskFiles.count)
        tableView!.beginUpdates()
        let index = diskFiles.filter{$0.isDirectory}.count-1
        tableView!.insertRows(at: [IndexPath(row: index, section: 1)], with: .automatic)
        tableView!.endUpdates()
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
        filePath = url
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
    
    public func image() -> UIImage? {
        let bundle =  Bundle.main
        var fileName = String()
        switch fileType {
        case .Directory: fileName = "folder@2x.png"
        case .JPG, .PNG, .GIF: fileName = "image@2x.png"
        case .PDF: fileName = "pdf@2x.png"
        case .ZIP: fileName = "zip@2x.png"
        default: fileName = "file@2x.png"
        }
        let file = UIImage(named: fileName, in: bundle, compatibleWith: nil)
        return file
    }
}
