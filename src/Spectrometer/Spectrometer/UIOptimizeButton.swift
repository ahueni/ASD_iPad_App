//
//  UIOptimizeButton.swift
//  Spectrometer
//
//  Created by raphi on 21.03.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

@IBDesignable
class UIOptimizeButton: UIColorButton {
    
    var integrationTimeLabel: UILabel!
    var swir1GainLabel: UILabel!
    var swir2GainLabel: UILabel!
    
    var integrationTime: Int? {
        didSet {
            integrationTimeLabel.text = "IT: " + (integrationTime?.description)!
        }
    }
    
    var swir1Gain: Int? {
        didSet {
            swir1GainLabel.text = "S1G: " + (swir1Gain?.description)!
        }
    }
    
    var swir2Gain: Int? {
        didSet {
            swir2GainLabel.text = "S2G: " + (swir2Gain?.description)!
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // replace title label
        if let titleLabel = self.titleLabel {
            let titleLabelFrame = titleLabel.frame
            let newtitleLabelFrame = CGRect(x: titleLabelFrame.origin.x, y: 2, width: titleLabelFrame.width, height: titleLabelFrame.height)
            self.titleLabel?.frame = newtitleLabelFrame
        }
        
        // arrange sublabels
        let width = (self.frame.width - 8) / 3
        let height:CGFloat = 14
        
        let x1:CGFloat = 2
        let x2:CGFloat = x1 + width + 2
        let x3:CGFloat = x2 + width + 2
        
        let y:CGFloat = self.frame.height - 16
        
        integrationTimeLabel.frame = CGRect(x: x1, y: y, width: width, height: height)
        swir1GainLabel.frame = CGRect(x: x2, y: y, width: width, height: height)
        swir2GainLabel.frame = CGRect(x: x3, y: y, width: width, height: height)
        
        
        print(integrationTimeLabel.frame.height)
        
        
    }
    
    func initViews() -> Void {
        
        integrationTimeLabel = UILabel()
        swir1GainLabel = UILabel()
        swir2GainLabel = UILabel()
        
        integrationTimeLabel.font = UIFont.defaultFontRegular(size: 8)
        swir1GainLabel.font = UIFont.defaultFontRegular(size: 8)
        swir2GainLabel.font = UIFont.defaultFontRegular(size: 8)
        
        integrationTimeLabel.textColor = UIColor.white
        swir1GainLabel.textColor = UIColor.white
        swir2GainLabel.textColor = UIColor.white
        
        integrationTimeLabel.textAlignment = .center
        swir1GainLabel.textAlignment = .center
        swir2GainLabel.textAlignment = .center
        
        integrationTimeLabel.text = "IT: -"
        swir1GainLabel.text = "S1G: -"
        swir2GainLabel.text = "S2G: -"
        
        self.addSubview(integrationTimeLabel)
        self.addSubview(swir1GainLabel)
        self.addSubview(swir2GainLabel)
        
    }
    
}
