//
//  RadioButton.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 14.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class RadioButton: UIButton {
    
    var alternateButton:[RadioButton] = []
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = backgroundColor?.withAlphaComponent(1.0)
            } else {
                backgroundColor = backgroundColor?.withAlphaComponent(0.25)
            }
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0
    
    @IBInspectable var isLeft: Bool = false {
        didSet {
            //round(corners: [.topLeft, .bottomLeft], radius: cornerRadius)
        }
    }
    
    @IBInspectable var isRight: Bool = false {
        didSet {
            //round(corners: [.topRight, .bottomRight], radius: cornerRadius)
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
    
    func initViews() {
        if isSelected {
            backgroundColor = backgroundColor?.withAlphaComponent(1.0)
        } else {
            backgroundColor = backgroundColor?.withAlphaComponent(0.25)
        }
    }
    
    func unselectAlternateButtons(){
        if alternateButton.isEmpty {
            self.isSelected = !isSelected
        } else {
            self.isSelected = true
            for aButton:RadioButton in alternateButton {
                aButton.isSelected = false
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        unselectAlternateButtons()
    }
    
}
