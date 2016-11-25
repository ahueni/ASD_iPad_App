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
    
    // colors
    let red = UIColor.red
    let black = UIColor.black
    let green = UIColor.green
    
    // text fields
    @IBOutlet var name: UITextField!
    @IBOutlet var ipAdress: UITextField!
    @IBOutlet var port: UITextField!
    
    // buttons
    @IBOutlet var lmpButton: UIButton!
    @IBOutlet var refButton: UIButton!
    @IBOutlet var illButton: UIButton!
    
    @IBOutlet var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nameNextClick(_ sender: Any) {
        ipAdress.becomeFirstResponder()
    }
    
    @IBAction func nameEditEnd(_ sender: Any) {
        if validateName() {
            name.textColor = black
        } else {
            name.textColor = red
        }
        toggleSaveButton()
    }
    
    @IBAction func ipAdressNextClick(_ sender: Any) {
        port.becomeFirstResponder()
    }
    
    @IBAction func ipAdressEditEnd(_ sender: Any) {
        if validateIp() {
            ipAdress.textColor = black
        } else {
            ipAdress.textColor = red
        }
        toggleSaveButton()
    }
    
    @IBAction func portNextClick(_ sender: UITextField, forEvent event: UIEvent) {
        view.endEditing(true)
    }
    
    @IBAction func portEditEnd(_ sender: UITextField, forEvent event: UIEvent) {
        if validatePort() {
            port.textColor = black
        } else {
            port.textColor = red
        }
        toggleSaveButton()
    }
    
    @IBAction func selectLMPFile(_ sender: Any) {
        
        present(fileBrowser, animated: true, completion: nil)
        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
            self.lmpButton.setTitle(file.displayName, for: UIControlState.normal)
            self.lmpButton.setTitleColor(self.green, for: UIControlState.normal)        }
        
    }
    
    @IBAction func selectREFFile(_ sender: Any) {
        
        present(fileBrowser, animated: true, completion: nil)
        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
            self.refButton.setTitle(file.displayName, for: UIControlState.normal)
            self.refButton.setTitleColor(self.green, for: UIControlState.normal)
        }
        
    }
    
    @IBAction func selectILLFile(_ sender: Any) {
        
        present(fileBrowser, animated: true, completion: nil)
        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
            self.illButton.setTitle(file.displayName, for: UIControlState.normal)
            self.illButton.setTitleColor(self.green, for: UIControlState.normal) 
        }
        
    }
    
    private func validateName() -> Bool {
        if (name.text == nil || name.text == "") {
            return false
        }
        return true
    }
    
    private func validateIp() -> Bool {
        if !Regex.valideIp(ip: ipAdress.text) {
            return false
        }
        return true
    }
    
    private func validatePort() -> Bool {
        let portNumber = Int(port.text!)
        if (portNumber == nil || (portNumber! < 1 || portNumber! > 65535)) {
            return false
        }
        return true
    }
    
    private func toggleSaveButton() -> Void {
        if (validateName() && validateIp() && validatePort()) {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    
    
}
