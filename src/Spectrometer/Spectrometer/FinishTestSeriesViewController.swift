//
//  FinishTestSeriesViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 18.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class FinishTestSeriesViewController : TestSeriesViewController{
    
    
    @IBAction func finishButtonClicked(_ sender: UIButton) {
        
        for i in 0...(pageContainer?.spectrums)!.count-1{
            var spectrumTuple = pageContainer?.spectrums[i]
            var fileName = pageContainer?.measurmentSettings.fileName
            fileName?.insert(contentsOf: i.description.characters, at: (fileName?.characters.index(of: "."))!)
            let relativeFilePath = pageContainer?.measurmentSettings.path?.appendingPathComponent(fileName!).relativePath
            let fileWriter = FileWriter(path: relativeFilePath!)
            fileWriter.write(spectrum: (spectrumTuple?.spectrum)!, whiteRefrenceSpectrum: (spectrumTuple?.whiteRefrenceSpectrum)!)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
