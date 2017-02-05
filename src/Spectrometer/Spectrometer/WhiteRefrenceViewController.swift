//
//  WhiteRefrenceViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 30.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class WhiteRefrenceViewController : BaseMeasurementModal {
    
    @IBOutlet var whiteReferenceButton: LoadingButton!
    @IBOutlet var nextButton: UIBlueButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func TakeWhiteRefrenceButtonClicked(_ sender: UIButton) {
        
        whiteReferenceButton.showLoading()
        self.nextButton.isEnabled = false
        
        // switch to background thread for aquire white reference
        DispatchQueue.global().async {
            let spectrum = CommandManager.sharedInstance.aquire(samples: self.appDelegate.config!.sampleCountWhiteRefrence)
            self.updateValues(whiteReference: spectrum)
        }
        
    }
    
    func updateValues(whiteReference: FullRangeInterpolatedSpectrum) -> Void {
        
        // switch back to UI Thread for updates
        DispatchQueue.main.async {
            
            switch(self.pageContainer!.measurmentSettings!.whiteRefrenceSetting){
                case .TakeBefore:
                    self.pageContainer!.whiteRefrenceBefore = whiteReference
                case .TakeBeforeAndAfter:
                    if(self.pageContainer!.whiteRefrenceBefore == nil) {
                        self.pageContainer!.whiteRefrenceBefore = whiteReference
                    } else {
                        self.pageContainer!.whiteRefrenceAfter = whiteReference
                        self.nextButton.setTitle("Fertig", for: .normal)
                    }
                case .TakeAfter:
                    self.pageContainer!.whiteRefrenceAfter = whiteReference
                    self.nextButton.setTitle("Fertig", for: .normal)
            }
            
            self.updateLineChart(spectrum: whiteReference)
            
            self.nextButton.isEnabled = true
            self.whiteReferenceButton.hideLoading()
            
        }
        
    }
    
}
