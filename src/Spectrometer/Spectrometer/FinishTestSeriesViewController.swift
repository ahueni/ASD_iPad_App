//
//  FinishTestSeriesViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 18.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class FinishTestSeriesViewController : BaseMeasurementModal{
    
    
    @IBAction func finishButtonClicked(_ sender: UIButton) {
        
        for i in 0...(pageContainer!.spectrumDataList).count-1{
            let spectrumData = pageContainer!.spectrumDataList[i]
            let fileName = pageContainer!.measurmentSettings!.fileName + i.description + ".asd"
            let relativeFilePath = pageContainer!.measurmentSettings!.path.appendingPathComponent(fileName).relativePath
            let fileWriter = FileWriter(path: relativeFilePath)
            fileWriter.write(spectrum: spectrumData.spectrum, whiteRefrenceSpectrum: spectrumData.whiteRefrence!)
        }
        
        dismiss(animated: true, completion: nil)
    }
}
