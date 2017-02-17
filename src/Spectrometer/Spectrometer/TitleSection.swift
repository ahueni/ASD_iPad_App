//
//  TitleSection.swift
//  Spectrometer
//
//  Created by raphi on 17.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable class TitleSection: UIView {
    
    var titleLabel:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
    }
    
    @IBInspectable var title: String = "Title" {
        didSet {
            titleLabel.text = title
        }
    }
    
    func addSubviews() -> Void {
        
        // add titleLabel
        titleLabel = UILabel()
        addSubview(titleLabel)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // layout titleSection
        layer.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00).cgColor
        layer.addBorder(edge: .bottom, color: UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.00), thickness: 1)
        
        // layout titleLabel
        let titleFrame = CGRect(x: 10, y: 5, width: self.layer.frame.width - 20, height: self.layer.frame.height - 10)
        titleLabel.frame = titleFrame
        titleLabel.textColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.00)
        titleLabel.font = UIFont.defaultFontBold(size: 16)
        titleLabel.minimumScaleFactor = 8
        titleLabel.numberOfLines = 1
        titleLabel.textAlignment = .center
        
    }
    
}
