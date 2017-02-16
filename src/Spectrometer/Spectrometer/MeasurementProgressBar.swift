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

@IBDesignable class CustomProgressBar : UIView {
    
    fileprivate var totalValue:Int = 0
    
    @IBInspectable var fontColor: UIColor = UIColor.clear
    @IBInspectable var fontSize:CGFloat = 14
    
    @IBInspectable var barColor: UIColor = UIColor.clear {
        didSet {
            layer.backgroundColor = barColor.withAlphaComponent(0.25).cgColor
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // add progress view
        let progressFrame = CGRect(x: 0, y: 0, width: 0, height: self.layer.frame.height)
        let progressView = UIView(frame: progressFrame)
        progressView.layer.cornerRadius = cornerRadius
        progressView.layer.backgroundColor = barColor.cgColor
        
        // add countLabel
        let countFrame = CGRect(x: 8, y: 0, width: 65, height: self.layer.frame.height)
        var countLabel = UILabel(frame: countFrame)
        countLabel.text = "CountLabel"
        //countLabel.textColor = fontColor
        //countLabel.font = UIFont(name: "OpenSans", size: 13)?.withSize(fontSize)
        
        addSubview(countLabel)
        addSubview(progressView)
        
        sendSubview(toBack: progressView)
        
    }
    
    func initialize(total: Int) {
        totalValue = total
        
    }
    
}
