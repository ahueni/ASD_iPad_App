//
//  BaseCalibrationSelectInput.swift
//  Spectrometer
//
//  Created by raphi on 21.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class BaseCalibrationFileSelectInput: BaseSelectInput {
    
    override var isValid: Bool {
        get {
            
            if isInEditMode {
                return true
            }
            
            return calibrationFile != nil
        }
    }
    
    // in edit mode it's not nescessary to select a file only if the user wants to override it
    var isInEditMode: Bool = false
    
    var calibrationFile: SpectralFileBase?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        leftImageView.image = UIImage.fontAwesomeIcon(name: .fileO, textColor: .white, size: CGSize(width: iconSize, height: iconSize))
    }
    
    override func update(selectedPath: URL) {
        _selectedPath = selectedPath
        
        // reset edit mode to activate validation
        isInEditMode = false
        
        if (selectedPath.exists()) {
            
            let fileData = [UInt8](FileManager.default.contents(atPath: selectedPath.relativePath)!)
            let configurationFileReader = IndicoIniFileReader(data: fileData)

            do {
                calibrationFile = try configurationFileReader.parse()
            } catch let error as ParsingError {
                print(error.message)
            } catch {
                fatalError("somthing went wrong!")
            }
            
        }
        
        self.validate()
        self.delegate.didSelectPath()
    }
    
}
