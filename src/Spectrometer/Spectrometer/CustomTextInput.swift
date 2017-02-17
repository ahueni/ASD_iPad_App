//
//  CustomTextInput.swift
//  Spectrometer
//
//  Created by raphi on 17.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

@IBDesignable class CustomTextField:UITextField {
    
    var leftSpaceView:UIView!
    var leftBackgroundView:UIView!
    var leftImageView:UIImageView!
    var leftIcon:UIImage!
    
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var iconBackgroundColor: UIColor = UIColor.clear {
        didSet {
            leftBackgroundView.backgroundColor = iconBackgroundColor
        }
    }
    
    @IBInspectable var leftTextSpace: CGFloat = 10 {
        didSet {
            leftSpaceView.frame = CGRect(x: 0, y: 0, width: self.frame.height + leftTextSpace, height: self.frame.height)
        }
    }
    
    @IBInspectable var iconSize: Int = 16 {
        didSet {
            leftIcon = UIImage.fontAwesomeIcon(name: .fileTextO, textColor: .white, size: CGSize(width: iconSize, height: iconSize))
            leftImageView.frame = CGRect(origin: leftBackgroundView.center, size: CGSize(width: iconSize, height: iconSize))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.leftViewMode = .always
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.leftViewMode = .always
        addSubviews()
    }
    
    func addSubviews() {
        leftSpaceView = UIView()
        leftBackgroundView = UIView()
        leftImageView = UIImageView()
        leftBackgroundView.addSubview(leftImageView)
        leftSpaceView.addSubview(leftBackgroundView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // layout customTextField
        self.backgroundColor = UIColor.white
        
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
        
        // style LeftSpaceView
        leftSpaceView.frame = CGRect(x: 0, y: 0, width: self.frame.height + leftTextSpace, height: self.frame.height)
        leftSpaceView.backgroundColor = backgroundColor
        
        // style LeftBackgroundView
        leftBackgroundView.bringSubview(toFront: leftImageView)
        leftBackgroundView.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)
        leftBackgroundView.backgroundColor = iconBackgroundColor
        
        // style ImageView
        leftImageView.image = leftIcon
        leftImageView.frame = CGRect(origin: leftBackgroundView.center, size: CGSize(width: iconSize, height: iconSize))
        leftImageView.center = leftBackgroundView.center
        
        self.leftView = leftSpaceView
        
    }
    
}
