//
//  AddEditConnectionViewController.swift
//  Spectrometer
//
//  Created by raphi on 19.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class AddEditConnectionViewController: UIViewController, UITextFieldDelegate, BaseSelectInputDelegate, UITableViewDelegate, UITableViewDataSource {

    let fileManager:FileManager = FileManager.default
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let dataViewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // config object
    internal var config: SpectrometerConfig!
    
    // text fields
    @IBOutlet var name: UITextField!
    @IBOutlet var ipAdress: UITextField!
    @IBOutlet var port: UITextField!
    
    // choose calibrationFiles
    @IBOutlet var absoluteReflectanceSelect: AbsoluteReflectanceFileSelectInput!
    @IBOutlet var baseFileSelect: BaseFileSelectInput!
    @IBOutlet var lampFileSelect: LampFileSelectInput!
    
    @IBOutlet var fiberOpticFilesTableView: UITableView!
    @IBOutlet var fiberOpticsTableViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set delegates
        name.delegate = self
        ipAdress.delegate = self
        port.delegate = self
        
        absoluteReflectanceSelect.delegate = self
        baseFileSelect.delegate = self
        lampFileSelect.delegate = self
        
        fiberOpticFilesTableView.delegate = self
        fiberOpticFilesTableView.dataSource = self
        
        fiberOpticFilesTableView.register(UINib(nibName: "FiberOpticFileTableViewCell", bundle: nil), forCellReuseIdentifier: "FiberOpticFileTableViewCell")
        fiberOpticFilesTableView.layer.cornerRadius = 4.0
        
        // create config if not set -> for edit-mode, a config must be set with the initData methode
        if self.config == nil {
            self.config = SpectrometerConfig(context: dataViewContext)
        } else {
            
            // init controls
            self.name.text = config.name
            self.ipAdress.text = config.ipAdress
            self.port.text = config.port.description
            
            self.absoluteReflectanceSelect.pathLabel.text = "Replace " + (config.absoluteReflectance?.name)!
            self.absoluteReflectanceSelect.isInEditMode = true
            
            self.baseFileSelect.pathLabel.text = "Replace " + (config.base?.name)!
            self.baseFileSelect.isInEditMode = true
            
            self.lampFileSelect.pathLabel.text = "Replace " + (config.lamp?.name)!
            self.lampFileSelect.isInEditMode = true
            
            validateControls()
            
        }
        
        reloadTableData()
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dataViewContext.rollback()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func savePressed(_ sender: Any) {
        
        config.name = name.text
        config.ipAdress = ipAdress.text
        config.port = Int16(port.text!)!
        
        if !absoluteReflectanceSelect.isInEditMode {
            
            if config.absoluteReflectance == nil {
                
                let absoluteReflectance = CalibrationFile(context: dataViewContext)
                absoluteReflectance.name = "Absolute Reflectance"
                absoluteReflectance.filename = absoluteReflectanceSelect.pathLabel.text
                absoluteReflectance.type = Int16(CalibrationType.AbsoluteReflectanceFile.rawValue)
                
                if let caliFile = absoluteReflectanceSelect.calibrationFile {
                    absoluteReflectance.spectrum = caliFile.spectrum
                    absoluteReflectance.integrationTime = Int32(caliFile.integrationTime)
                    absoluteReflectance.swir1Gain = Int16(caliFile.swir1Gain)
                    absoluteReflectance.swir2Gain = Int16(caliFile.swir2Gain)
                }
                
                config.absoluteReflectance = absoluteReflectance
            } else {
                
                config.absoluteReflectance?.name = absoluteReflectanceSelect.pathLabel.text
                
                if let caliFile = absoluteReflectanceSelect.calibrationFile {
                    config.absoluteReflectance?.spectrum = caliFile.spectrum
                    config.absoluteReflectance?.integrationTime = Int32(caliFile.integrationTime)
                    config.absoluteReflectance?.swir1Gain = Int16(caliFile.swir1Gain)
                    config.absoluteReflectance?.swir2Gain = Int16(caliFile.swir2Gain)
                }
            }
            
        }
        
        if !baseFileSelect.isInEditMode {
            
            if config.base == nil {
                
                let base = CalibrationFile(context: dataViewContext)
                base.name = "Base"
                base.filename = baseFileSelect.pathLabel.text
                base.type = Int16(CalibrationType.BaseFile.rawValue)
                
                if let caliFile = baseFileSelect.calibrationFile {
                    base.spectrum = caliFile.spectrum
                    base.integrationTime = Int32(caliFile.integrationTime)
                    base.swir1Gain = Int16(caliFile.swir1Gain)
                    base.swir2Gain = Int16(caliFile.swir2Gain)
                }
                
                config.base = base
            } else {
                config.base?.name = baseFileSelect.pathLabel.text
                
                if let caliFile = baseFileSelect.calibrationFile {
                    config.base?.spectrum = caliFile.spectrum
                    config.base?.integrationTime = Int32(caliFile.integrationTime)
                    config.base?.swir1Gain = Int16(caliFile.swir1Gain)
                    config.base?.swir2Gain = Int16(caliFile.swir2Gain)
                }
                
            }
            
        }
        
        if !lampFileSelect.isInEditMode {
            
            if config.lamp == nil {
                let lamp = CalibrationFile(context: dataViewContext)
                lamp.name = "Lamp"
                lamp.filename = lampFileSelect.pathLabel.text
                lamp.type = Int16(CalibrationType.LampFile.rawValue)
                
                if let caliFile = lampFileSelect.calibrationFile {
                    lamp.spectrum = caliFile.spectrum
                    lamp.integrationTime = Int32(caliFile.integrationTime)
                    lamp.swir1Gain = Int16(caliFile.swir1Gain)
                    lamp.swir2Gain = Int16(caliFile.swir2Gain)
                }
                
                config.lamp = lamp
            } else {
                config.lamp?.name = lampFileSelect.pathLabel.text
                
                if let caliFile = lampFileSelect.calibrationFile {
                    config.lamp?.spectrum = caliFile.spectrum
                    config.lamp?.integrationTime = Int32(caliFile.integrationTime)
                    config.lamp?.swir1Gain = Int16(caliFile.swir1Gain)
                    config.lamp?.swir2Gain = Int16(caliFile.swir2Gain)
                }
                
            }
            
        }
        
        config.sampleCount = 10 //default value for sampleCount
        config.sampleCountDarkCurrent = 10 //default value for sampleCount
        config.sampleCountWhiteRefrence = 10 //default value for sampleCount
        config.measurmentCount = 10 //default value for measurmentCount
        
        appDelegate.saveContext()
        
        NotificationCenter.default.post(name: .reloadSpectrometerConfig, object: nil)
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func initData(config: SpectrometerConfig) -> Void {
        if self.config != nil {
            fatalError("data must be initialized before viewDidLoad")
        }
        self.config = config
    }
    
    func openFileBrowser(path: URL?, sender: BaseSelectInput) {
        
        let fileBrowserContainerViewController = self.storyboard!.instantiateViewController(withIdentifier: "FileBrowserContainerViewController") as! FileBrowserContainerViewController
        
        let navigationController = UINavigationController(rootViewController: fileBrowserContainerViewController)
        navigationController.modalPresentationStyle = .formSheet
        
        // Hook up the select event
        fileBrowserContainerViewController.didSelectFile = {(file: DiskFile) -> Void in
            sender.update(selectedPath: file.filePath)
        }
        
        present(navigationController, animated: true, completion: nil)
        
    }
    
    // handle all text field and select delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        validateControls()
    }
    
    // finish button pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        validateControls()
        return textField.resignFirstResponder()
    }
    
    func didSelectPath() {
        validateControls()
    }
    
    internal func validateControls(){
        if ValidationManager.sharedInstance.validateSubViews(view: self.view) && fiberOpticFiles.count > 0 {
            self.saveButton.isEnabled = true
        } else {
            self.saveButton.isEnabled = false
        }
    }
    
    /*
    ForeOptics tableview definitions
    */
    internal var fiberOpticFiles:[CalibrationFile] = []
    
    func reloadTableData() -> Void {
        fiberOpticFiles = self.config.fiberOpticCalibrations?.allObjects as! [CalibrationFile]
        fiberOpticFilesTableView.reloadData()
        calcualteTableViewHeight()
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = fiberOpticFilesTableView.dequeueReusableCell(withIdentifier: "FiberOpticFileTableViewCell", for: indexPath) as! FiberOpticFileTableViewCell
        cell.name.text = fiberOpticFiles[indexPath.row].name
        cell.fileName.text = fiberOpticFiles[indexPath.row].filename
        if (indexPath.row % 2 != 0) { cell.backView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25) }
        cell.iconImage.image = UIImage.fontAwesomeIcon(name: .fileO, textColor: .white, size: CGSize(width: 22, height: 22))
        
        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(deleteFiberOpticFile(sender:)), for: .touchUpInside)
        return cell
    }
    
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fiberOpticFiles.count
    }
    
    
    @IBAction func selectFiberOpticFile(_ sender: UIColorButton) {
        
        let fileBrowserContainerViewController = self.storyboard!.instantiateViewController(withIdentifier: "FileBrowserContainerViewController") as! FileBrowserContainerViewController
        
        let navigationController = UINavigationController(rootViewController: fileBrowserContainerViewController)
        navigationController.modalPresentationStyle = .formSheet
        
        // Hook up the select event
        fileBrowserContainerViewController.didSelectFile = {(file: DiskFile) -> Void in
            
            let fileData = [UInt8](FileManager.default.contents(atPath: file.filePath.relativePath)!)
            let configurationFileReader = IndicoIniFileReader(data: fileData)
            
            do {
                let calibrationFile = try configurationFileReader.parse()
                self.addFiberOpticFile(file: calibrationFile, filename: file.filePath.lastPathComponent, name: file.filePath.lastPathComponent)
            } catch let error as ParsingError {
                print(error.message)
            } catch {
                fatalError("somthing went wrong!")
            }
            
            
        }
        
        present(navigationController, animated: true, completion: nil)
        
    }
    
    
    internal func addFiberOpticFile(file: SpectralFileBase, filename: String, name: String) -> Void {
        
        let newCaliFile = CalibrationFile(context: self.dataViewContext)
        newCaliFile.filename = filename
        newCaliFile.name = name
        newCaliFile.spectrum = file.spectrum
        newCaliFile.type = Int16(CalibrationType.FiberOpticFile.rawValue)
        newCaliFile.integrationTime = Int32(file.integrationTime)
        newCaliFile.swir1Gain = Int16(file.swir1Gain)
        newCaliFile.swir2Gain = Int16(file.swir2Gain)
        
        config.addToFiberOpticCalibrations(newCaliFile)
        
        fiberOpticFilesTableView.beginUpdates()
        fiberOpticFiles.append(newCaliFile)
        fiberOpticFilesTableView.insertRows(at: [IndexPath(row: fiberOpticFiles.count-1, section: 0)], with: .top)
        fiberOpticFilesTableView.endUpdates()
        
        calcualteTableViewHeight()
        fiberOpticFilesTableView.reloadData()
        validateControls()
    }
    
    func deleteFiberOpticFile(sender: UIButton) -> Void {
        
        let calFile =  fiberOpticFiles[sender.tag]
        
        config.removeFromFiberOpticCalibrations(calFile)
        dataViewContext.delete(calFile)
        
        fiberOpticFilesTableView.beginUpdates()
        fiberOpticFiles.remove(at: sender.tag)
        fiberOpticFilesTableView.deleteRows(at: [IndexPath(row: sender.tag, section: 0)], with: .bottom)
        fiberOpticFilesTableView.endUpdates()
        
        calcualteTableViewHeight()
        fiberOpticFilesTableView.reloadData()
        validateControls()
    }
    
    internal func calcualteTableViewHeight() {
        fiberOpticsTableViewHeight.constant = CGFloat(fiberOpticFiles.count) * fiberOpticFilesTableView.rowHeight
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
}
