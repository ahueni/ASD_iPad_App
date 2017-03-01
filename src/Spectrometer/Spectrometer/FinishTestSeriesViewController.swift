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
        InstrumentSettingsCache.sharedInstance.cancelMeasurment = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BackgroundFileWriteManager.sharedInstance.addFinishWritingCallBack(callBack: finishedSaving)
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
