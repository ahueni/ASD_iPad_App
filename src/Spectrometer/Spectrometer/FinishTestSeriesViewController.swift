//
//  FinishTestSeriesViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 18.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class FinishTestSeriesViewController : BaseMeasurementModal {
    
    @IBOutlet var checkMarkImage: UIImageView!
    @IBOutlet var successSavingLabel: UILabel!
    
    @IBOutlet var finishButton: UIBlueButton!
    
    @IBOutlet var savingLabel: UILabel!
    @IBOutlet var savingSpinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkMarkImage.alpha = 0
        successSavingLabel.alpha = 0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DispatchQueue.global().async {
            
            for i in 0...(self.pageContainer!.spectrumDataList).count-1{
                let spectrumData = self.pageContainer!.spectrumDataList[i]
                let fileName = self.pageContainer!.measurmentSettings!.fileName + i.description + ".asd"
                let relativeFilePath = self.pageContainer!.measurmentSettings!.path.appendingPathComponent(fileName).relativePath
                
                let fileWriter = FileWriter(path: relativeFilePath)
                fileWriter.write(spectrum: spectrumData.spectrum, whiteRefrenceSpectrum: spectrumData.whiteRefrence!)
            }
            
            self.finishedSaving()
            
        }
        
    }
    
    func finishedSaving() -> Void {
        
        DispatchQueue.main.async {
            self.finishButton.isEnabled = true
            
            self.savingLabel.isHidden = true
            self.savingSpinner.stopAnimating()
            self.savingSpinner.isHidden = true
            
            UIView.transition(with: self.checkMarkImage, duration: 1.0, options: UIViewAnimationOptions.transitionFlipFromTop, animations: {
                
                self.checkMarkImage.alpha = 1
                self.successSavingLabel.alpha = 1
                
            }, completion: nil)
            
            
        }
        
    }
    
}
