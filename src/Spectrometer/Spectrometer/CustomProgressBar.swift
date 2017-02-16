//
//  MeasurementProgressBar.swift
//  Spectrometer
//
//  Created by raphi on 04.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomProgressBar : UIView {
    
    private var totalValue:Int = 0
    
    private var progressView:UIView?
    private var stateLabel:UILabel?
    private var countLabel:UILabel?
    
    @IBInspectable var fontColor: UIColor = UIColor.black
    
    @IBInspectable var fontSize:CGFloat = 14
    
    @IBInspectable var barColor: UIColor = UIColor.clear {
        didSet {
            layer.backgroundColor = barColor.withAlphaComponent(0.40).cgColor
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
        progressView = UIView(frame: progressFrame)
        progressView?.layer.cornerRadius = cornerRadius
        progressView?.layer.backgroundColor = barColor.cgColor
        
        // add countLabel
        let countFrame = CGRect(x: self.layer.frame.width - 85, y: 0, width: 75, height: self.layer.frame.height)
        countLabel = UILabel(frame: countFrame)
        countLabel?.textColor = fontColor
        countLabel?.text = "1000/1000"
        countLabel?.font = UIFont.defaultFontRegular(size: fontSize)
        countLabel?.textAlignment = .right
        
        // add stateLabel
        let stateFrame = CGRect(x: 10, y: 0, width: self.layer.frame.width - 85, height: self.layer.frame.height)
        stateLabel = UILabel(frame: stateFrame)
        stateLabel?.textColor = fontColor
        stateLabel?.text = "State..."
        stateLabel?.font = UIFont.defaultFontRegular(size: fontSize)
        
        addSubview(stateLabel!)
        addSubview(countLabel!)
        addSubview(progressView!)
        
    }
    
    func initialize(total: Int) {
        totalValue = total
        countLabel?.text = "0 / " + total.description
        stateLabel?.text = ""
    }
    
    func updateProgressBar(actual:Int, statusText: String) -> Void {
        
        if totalValue == 0 {
            fatalError("progress bar not initialized")
        }
        
        countLabel?.text = actual.description + " / " + totalValue.description
        stateLabel?.text = statusText
        
        let totalWidth = self.frame.width
        let oneStep = totalWidth / CGFloat(totalValue)
        let newWidth = (progressView?.frame.width)! + oneStep
        
        UIView.animate(withDuration: TimeInterval(1.0), animations: {
            self.progressView?.frame = CGRect(origin: (self.progressView?.frame.origin)!, size: CGSize(width: newWidth, height: (self.progressView?.frame.height)!))
        })
        
    }
    
}
