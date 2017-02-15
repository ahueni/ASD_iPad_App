//
//  SettingsBox.swift
//  Spectrometer
//
//  Created by raphi on 15.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class SettingsBox:UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.white
        
        let borderColor:UIColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.00)
        
        layer.borderColor = borderColor.cgColor
        
        layer.borderWidth = 1.0
        layer.cornerRadius = 2
        
        // AddHeaderRect
        let headerRect:CGRect = CGRect(x: 0, y: 0, width: layer.frame.width, height: 46)
        let headerView:UIView = UIView(frame: headerRect)
        headerView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00)
        headerView.layer.addBorder(edge: .bottom, color: borderColor, thickness: 1.0)
        addSubview(headerView)
        
        sendSubview(toBack: headerView)
        
        print("LAYOUT Subviews")
    }
    
}
