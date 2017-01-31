//
//  FileBrowserWithButtonsContainerViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 31.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class DirectoryBrowserContainerViewController : FileBrowserContainerViewController
{
    
    @IBAction func AddDirectoryButtonClicked(_ sender: UIButton) {
        let path : URL = selectedPath == nil ? documentsURL() : selectedPath!
        print("Add Folder: ")
        print(path)
        
        let alert = UIAlertController(title: "Neuer Ordner", message: "Wie soll der Ordner heissen?", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Ordner Name"
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            if(textField?.text == "" || self.containerViewController!.diskFiles.filter({$0.displayName == textField?.text}).count > 0){
                let error = UIAlertController(title: "Fehler", message: "Ordnername ist nicht korrekt oder es gibt bereits einen Ordner mit diesem Namen", preferredStyle: .alert)
                error.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(error, animated: true, completion: nil)
            }
            
            do{
                let createFolderPath = path.appendingPathComponent(textField!.text!)
                try self.fileManager.createDirectory(atPath: (createFolderPath.relativePath), withIntermediateDirectories: false, attributes: nil)
                
                self.containerViewController!.insertDiskFile(url: createFolderPath)
            }
            catch _
            {
                let error = UIAlertController(title: "Fehler", message: "Der Ordner konnte nicht erstellt werden", preferredStyle: .alert)
                error.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(error, animated: true, completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Abbrechen", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func ChooseDirectoryButtonClicked(_ sender: UIButton) {
        let selectedFolder = DiskFile(url: selectedPath == nil ? documentsURL() : selectedPath!)
        didSelectFile!(selectedFolder)
        dismiss(animated: true, completion: nil)
    }
    
    public func documentsURL() -> URL {
        return fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
    }

}
