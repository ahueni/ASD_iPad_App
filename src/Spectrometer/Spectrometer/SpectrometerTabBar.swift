//
//  SpectrometerTabBar.swift
//  Spectrometer
//
//  Created by raphi on 19.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

extension UITabBar {
    
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        
        super.sizeThatFits(size)
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 70
        return sizeThatFits
        
    }
    
}

class MyUITetField: UITextField {
    
    override func draw(_ rect: CGRect) {
        
        let startingPoint   = CGPoint(x: rect.minX, y: rect.maxY)
        let endingPoint     = CGPoint(x: rect.maxX, y: rect.maxY)
        
        let path = UIBezierPath()
        
        path.move(to: startingPoint)
        path.addLine(to: endingPoint)
        
        path.lineWidth = 2.0
        
        tintColor.setStroke()
        
        path.stroke()
    }
    
}
