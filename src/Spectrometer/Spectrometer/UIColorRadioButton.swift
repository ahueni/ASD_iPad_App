//
//  RadioButton.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 14.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RadioButton: UIColorButton {
    
    var alternateButton:[RadioButton] = []
    
    override var isSelected: Bool {
        didSet {
            changeButtonBackground()
        }
    }
    
    override var isEnabled: Bool {
        didSet {
            changeButtonBackground()
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
        changeButtonBackground()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        unselectAlternateButtons()
    }
    
    func initViews() {
        changeButtonBackground()
    }
    
    internal func unselectAlternateButtons() {
        if alternateButton.isEmpty {
            self.isSelected = !isSelected
        } else {
            self.isSelected = true
            for aButton:RadioButton in alternateButton {
                aButton.isSelected = false
            }
        }
    }
    
    internal func changeButtonBackground() {
        
        // get actual font size to set new font with same size
        let acutalFontSize = (self.titleLabel?.font.pointSize)!
        
        if state.contains(.disabled) {
            backgroundColor = backgroundColor?.withAlphaComponent(0.2)
            self.titleLabel?.font = UIFont.defaultFontRegular(size: acutalFontSize)
        } else if state.contains(.selected) {
            backgroundColor = backgroundColor?.withAlphaComponent(1.0)
            self.titleLabel?.font = UIFont.defaultFontRegular(size: acutalFontSize)
        } else {
            backgroundColor = backgroundColor?.withAlphaComponent(0.6)
            self.titleLabel?.font = UIFont.defaultFontRegular(size: acutalFontSize)
        }
        
    }
    
}
