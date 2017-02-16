//
//  MeasurementProgressBar.swift
//  Spectrometer
//
//  Created by raphi on 04.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class MeasurementProgressBar : UIView {
    
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var stateLabel: UILabel!
    @IBOutlet var progressView: UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 4
    }
    
    func initialize(total: Int) {
        countLabel.text = "0 / " + total.description
        stateLabel.text = ""
    }
    
    func updateProgressBar(actual:Int, total:Int, statusText: String) -> Void {
        countLabel.text = actual.description + " / " + total.description
        stateLabel.text = statusText
        
        progressView.layer.cornerRadius = 4
        let totalWidth = self.frame.width
        let oneStep = totalWidth / CGFloat(total)
        let newWidth = progressView.frame.width + oneStep
        
        UIView.animate(withDuration: TimeInterval(1.0), animations: {
            self.progressView.frame = CGRect(origin: self.progressView.frame.origin, size: CGSize(width: newWidth, height: self.progressView.frame.height))
        })
        
    }
    
    
    
}


