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
    let fileManager:FileManager = FileManager.default
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let dataViewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
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
    
    // refrence files
    var lmpFile: SpectralFileBase?
    
    
    override func viewDidLoad() {
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        print(path?.absoluteString ?? "kein Pfad")
        
        super.viewDidLoad()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        let config = SpectrometerConfig(context: dataViewContext)
        
        config.name = name.text
        config.ipAdress = ipAdress.text
        config.port = Int16(port.text!)!
        
        appDelegate.saveContext()
        
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
    
            if (!self.validateLMPFile(filePath: file.filePath.path)) {
                self.showWarningMessage(title: "Dateifehler", message: "Diese Datei konnte nicht geöffnet und verarbeitet werden. Bitte verwenden sie eine korrekte LMP Initialiserungsdatei")
            } else {
                self.lmpButton.setTitle(file.displayName, for: UIControlState.normal)
                self.lmpButton.setTitleColor(self.green, for: UIControlState.normal)
                self.toggleSaveButton()
            }
            
        }
        
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
    
    private func validateLMPFile(filePath: String) -> Bool {
        
        let dataBuffer = [UInt8](self.fileManager.contents(atPath: filePath)!)
        
        let fileParser = SpectralFileParser(data: dataBuffer)
        
        let test = fileParser.parse()
        
        print(test.fileVersion)
        
        // parseSpectralFile and validate it
        
        return false
    }
    
    private func toggleSaveButton() -> Void {
        if (validateName() && validateIp() && validatePort()) {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    
    
}
