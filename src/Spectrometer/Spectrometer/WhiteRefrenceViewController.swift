//
//  WhiteRefrenceViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 30.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class WhiteRefrenceViewController : BaseMeasurementModal{
    @IBAction func TakeWhiteRefrenceButtonClicked(_ sender: UIButton) {
        let spectrum = CommandManager.sharedInstance.aquire(samples: appDelegate.config!.sampleCountWhiteRefrence)
        
        switch(pageContainer!.measurmentSettings!.whiteRefrenceSetting){
        case .TakeBefore:
            pageContainer!.whiteRefrenceBefore = spectrum
        case .TakeBeforeAndAfter:
            if(pageContainer!.whiteRefrenceBefore == nil)
            {
                pageContainer!.whiteRefrenceBefore = spectrum
            }
            else{
                pageContainer!.whiteRefrenceAfter = spectrum
            }
        case .TakeAfter:
            pageContainer!.whiteRefrenceAfter = spectrum
        }
        
        
        updateLineChart(spectrum: spectrum)
    }
}
