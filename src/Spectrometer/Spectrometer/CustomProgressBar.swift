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
    
    private var progressView:UIView!
    private var stateLabel:UILabel!
    private var countLabel:UILabel!
    
    @IBInspectable var fontColor: UIColor = UIColor.black
    
    @IBInspectable var fontSize:CGFloat = 14 {
        didSet {
            stateLabel.font = UIFont.defaultFontRegular(size: fontSize)
            countLabel.font = UIFont.defaultFontRegular(size: fontSize)
        }
    }
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubveiws()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubveiws()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // layout progress view
        progressView.layer.cornerRadius = cornerRadius
        progressView.layer.backgroundColor = barColor.cgColor
        
        // add countLabel
        countLabel.frame = CGRect(x: self.layer.frame.width - 85, y: 0, width: 75, height: self.layer.frame.height)
        countLabel.textColor = fontColor
        countLabel.font = UIFont.defaultFontRegular(size: fontSize)
        countLabel.textAlignment = .right
        
        // add stateLabel
        stateLabel.frame = CGRect(x: 10, y: 0, width: self.layer.frame.width - 85, height: self.layer.frame.height)
        stateLabel.textColor = fontColor
        stateLabel.font = UIFont.defaultFontRegular(size: fontSize)
        
    }
    
    func addSubveiws() {
        
        // add progress view
        progressView = UIView()
        progressView.frame = CGRect(x: 0, y: 0, width: 0, height: self.layer.frame.height)
        
        // add count label
        countLabel = UILabel()
        countLabel.text = "1000/1000"
        
        // add stateLabel
        stateLabel = UILabel()
        stateLabel.text = "State..."
        
        addSubview(progressView)
        addSubview(stateLabel)
        addSubview(countLabel)
        
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
        
        countLabel.text = actual.description + " / " + totalValue.description
        stateLabel.text = statusText
        
        let totalWidth = self.frame.width
        let oneStep = totalWidth / CGFloat(totalValue)
        let newWidth = CGFloat(actual) * oneStep
        
        UIView.animate(withDuration: TimeInterval(1.0), animations: {
            self.progressView.frame = CGRect(origin: self.progressView.frame.origin, size: CGSize(width: newWidth, height: self.progressView.frame.height))
        })
        
    }
    
}
