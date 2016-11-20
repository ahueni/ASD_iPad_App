//
//  AddEditConnectionViewController.swift
//  Spectrometer
//
//  Created by raphi on 19.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit
import FileBrowser

class AddEditConnectionViewController: UIViewController {
    
    let fileBrowser = FileBrowser()
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollContainer: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(documentsUrl)
        
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func selectLMPFile(_ sender: Any) {
        
        present(fileBrowser, animated: true, completion: nil)
        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
            print(file.displayName)
        }
        
    }
    
    @IBAction func selectREFFile(_ sender: Any) {
        
        present(fileBrowser, animated: true, completion: nil)
        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
            print(file.displayName)
        }
        
    }
    
    @IBAction func selectILLFile(_ sender: Any) {
        
        present(fileBrowser, animated: true, completion: nil)
        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
            print(file.displayName)
        }
        
    }
    
    
    
}
