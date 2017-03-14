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
    
    @IBOutlet var checkMarkImage: UIImageView! {
        didSet {
            let darkPastelGreen = UIColor(red:0.09, green:0.76, blue:0.28, alpha:1.00)
            let imageSize = checkMarkImage.frame.size
            checkMarkImage.image = UIImage.fontAwesomeIcon(name: .checkCircleO, textColor: darkPastelGreen, size: imageSize)
        }
    }
    
    @IBOutlet var measurmentFinishedLabel: UILabel!
    @IBOutlet var finishButton: UIBlueButton!
    
    @IBOutlet var savingLabel: UILabel!
    @IBOutlet var savingSpinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkMarkImage.alpha = 0
        ViewStore.sharedInstance.cancelMeasurment = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FileWriteManager.sharedInstance.addFinishWritingCallBack(callBack: finishedSaving)
    }
    
    func finishedSaving() -> Void {
        
        DispatchQueue.main.async {
            self.finishButton.isEnabled = true
            
            self.savingLabel.isHidden = true
            self.savingSpinner.stopAnimating()
            self.savingSpinner.isHidden = true
            self.measurmentFinishedLabel.isHidden = false
            
            UIView.transition(with: self.checkMarkImage, duration: 1.0, options: UIViewAnimationOptions.transitionFlipFromTop, animations: {
                
                self.checkMarkImage.alpha = 1
                
            }, completion: nil)
            
            
        }
        
    }
    
}
