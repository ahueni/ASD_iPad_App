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
    
    // config object
    var config: SpectrometerConfig? = nil
    
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
    
    // spectras
    var lmpSpectra: [Double]? = nil
    var refSpectra: [Double]? = nil
    var illSpectra: [Double]? = nil
    
    @IBOutlet var saveButton: UIButton!
    
    override func viewDidLoad() {
        
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        print(path?.absoluteString ?? "kein Pfad")
        
        // set values to lables if available in config
        if (self.config != nil) {
            self.name.text = config?.name
            self.ipAdress.text = config?.ipAdress
            self.port.text = config?.port.description
            self.lmpButton.setTitle("LMP Datei ersetzen", for: UIControlState.normal)
            self.lmpSpectra = config?.lmpSpectrum as? [Double]
            self.refButton.setTitle("REF Datei ersetzen", for: UIControlState.normal)
            self.refSpectra = config?.refSpectrum as? [Double]
            self.illButton.setTitle("ILL Datei ersetzen", for: UIControlState.normal)
            self.illSpectra = config?.illSpectrum as? [Double]
        }
        
        super.viewDidLoad()
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        print("Config Saved")
        
        // if its new create a new config
        if self.config == nil {
            self.config = SpectrometerConfig(context: dataViewContext)
        }
        
        config?.name = name.text
        config?.ipAdress = ipAdress.text
        config?.port = Int16(port.text!)!
        config?.lmpSpectrum = lmpSpectra as NSObject?
        config?.refSpectrum = refSpectra as NSObject?
        config?.illSpectrum = illSpectra as NSObject?
        config?.sampleCount = 10 //default value for sampleCount
        
        appDelegate.saveContext()
        NotificationCenter.default.post(name: .reloadSpectrometerConfig, object: nil)
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
            
            let parseResult = self.validateLMPFile(filePath: file.filePath.path)
            self.lmpButton.setTitle(file.displayName, for: UIControlState.normal)
            if (!parseResult) {
                self.lmpButton.setTitleColor(self.red, for: UIControlState.normal)
                self.lmpSpectra = nil
                self.toggleSaveButton()
            } else {
                self.lmpButton.setTitleColor(self.green, for: UIControlState.normal)
                self.toggleSaveButton()
            }
            
        }
        
    }
    
    @IBAction func selectREFFile(_ sender: Any) {
        
        present(fileBrowser, animated: true, completion: nil)
        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
            
            let parseResult = self.validateREFFile(filePath: file.filePath.path)
            self.refButton.setTitle(file.displayName, for: UIControlState.normal)
            if (!parseResult) {
                self.refButton.setTitleColor(self.red, for: UIControlState.normal)
                self.refSpectra = nil
                self.toggleSaveButton()
            } else {
                self.refButton.setTitleColor(self.green, for: UIControlState.normal)
                self.toggleSaveButton()
            }
            
        }
        
    }
    
    @IBAction func selectILLFile(_ sender: Any) {
        
        present(fileBrowser, animated: true, completion: nil)
        fileBrowser.didSelectFile = { (file: FBFile) -> Void in
            
            let parseResult = self.validateILLFile(filePath: file.filePath.path)
            self.illButton.setTitle(file.displayName, for: UIControlState.normal)
            if (!parseResult) {
                self.illButton.setTitleColor(self.red, for: UIControlState.normal)
                self.illSpectra = nil
                self.toggleSaveButton()
            } else {
                self.illButton.setTitleColor(self.green, for: UIControlState.normal)
                self.toggleSaveButton()
            }
            
        }
        
    }
    
    func setConfigData(config: SpectrometerConfig) -> Void {
        self.config = config
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
        
        let lmpFile = parseSpectralFile(filePath: filePath)
        
        if (lmpFile == nil) { return false }
        
        // TODO: Vaildate if its a REF File -> how??
        if (lmpFile?.dataType != DataType.RefType) {
            self.showWarningMessage(title: "Dateifehler", message: "Bitte wählen Sie eine LMP Datei aus.")
            return false
        }
        self.lmpSpectra = (lmpFile?.spectrum)!
        return true
    }
    
    private func validateREFFile(filePath: String) -> Bool {
        
        let refFile = parseSpectralFile(filePath: filePath)
        
        if (refFile == nil) { return false }
        
        // TODO: Vaildate if its a REF File -> how??
        if (refFile?.dataType != DataType.RefType) {
            self.showWarningMessage(title: "Dateifehler", message: "Bitte wählen Sie eine REF Datei aus.")
            return false
        }
        self.refSpectra = (refFile?.spectrum)!
        return true
    }
    
    private func validateILLFile(filePath: String) -> Bool {
        
        let illFile = parseSpectralFile(filePath: filePath)
        
        if (illFile == nil) { return false }
        
        // TODO: Vaildate if its a REF File -> how??
        if (illFile?.dataType != DataType.RefType) {
            self.showWarningMessage(title: "Dateifehler", message: "Bitte wählen Sie eine ILL Datei aus.")
            return false
        }
        self.illSpectra = (illFile?.spectrum)!
        return true
    }
    
    private func parseSpectralFile(filePath: String) -> SpectralFileBase? {
        
        let dataBuffer = [UInt8](self.fileManager.contents(atPath: filePath)!)
        let fileParser = SpectralFileParser(data: dataBuffer)
        var file: SpectralFileBase
        
        do {
            file = try fileParser.parse()
        } catch let error as ParsingError {
            self.showWarningMessage(title: "Fehler", message: error.message)
            return nil
        } catch {
            self.showWarningMessage(title: "Dateifehler", message: "Die Datei konnte nicht gelesen werden.")
            return nil
        }
        
        return file
    }
    
    private func toggleSaveButton() -> Void {
        
        if (validateName() && validateIp() && validatePort() && self.lmpSpectra != nil && self.illSpectra != nil && self.refSpectra != nil) {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    
    
}
