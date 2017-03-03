//
//  PathSelectInput.swift
//  Spectrometer
//
//  Created by raphi on 21.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class PathSelectInput: BaseSelectInput {
    
    override var isValid: Bool {
        get {
            if let path = selectedPath {
                return path.isDirectory()
            }
            return false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func updateFilePathLabel()
    {
        if isValid {
            let rootPath = InstrumentSettingsCache.sharedInstance.measurementsRoot
            pathLabel.text = self.selectedPath!.getDisplayPathFromRoot(rootPath: rootPath)
        }
    }
    
}
