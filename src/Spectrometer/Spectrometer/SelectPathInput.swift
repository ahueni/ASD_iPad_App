//
//  SelectPathInput.swift
//  Spectrometer
//
//  Created by raphi on 17.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit
import FontAwesome_swift

protocol SelectPathDelegate {
    func selectPath() -> DiskFile
}


@IBDesignable class SelectInputPath:UIView {
    
    var selectPathDelegate: SelectPathDelegate!
    
    private var _selectedPath:DiskFile?
    
    var selectedPath: String { return (_selectedPath?.filePath.relativePath)! }
    
    var leftBackgroundView:UIView!
    var leftImageView:UIImageView!
    var leftIcon:UIImage!
    var pathLabel:UILabel!
    var selectPathButton:UIButton!
    
    
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
    
    @IBInspectable var textColor: UIColor = UIColor.clear {
        didSet {
            pathLabel.textColor = textColor
        }
    }
    
    @IBInspectable var iconBackgroundColor: UIColor = UIColor.clear {
        didSet {
            leftBackgroundView.backgroundColor = iconBackgroundColor
        }
    }
    
    @IBInspectable var leftTextSpace: CGFloat = 10 {
        didSet {
            pathLabel.frame = CGRect(x: self.frame.height + leftTextSpace, y: 0, width: self.frame.height, height: self.frame.height)
        }
    }
    
    @IBInspectable var textSize: CGFloat = 16 {
        didSet {
            pathLabel.font = UIFont.defaultFontRegular(size: textSize)
        }
    }
    
    @IBInspectable var iconSize: Int = 16 {
        didSet {
            leftIcon = UIImage.fontAwesomeIcon(name: .folderOpenO, textColor: .white, size: CGSize(width: iconSize, height: iconSize))
            leftImageView.frame = CGRect(origin: leftBackgroundView.center, size: CGSize(width: iconSize, height: iconSize))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSubviews()
    }
    
    func addSubviews() {
        leftBackgroundView = UIView()
        leftImageView = UIImageView()
        leftBackgroundView.addSubview(leftImageView)
        pathLabel = UILabel()
        selectPathButton = UIButton()
        
        self.addSubview(leftBackgroundView)
        self.addSubview(pathLabel)
        self.addSubview(selectPathButton)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectPath(sender:)))
        self.addGestureRecognizer(tapGesture)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // layout selectInputPath view
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.cornerRadius = cornerRadius
        
        // style LeftBackgroundView
        leftBackgroundView.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)
        leftBackgroundView.backgroundColor = iconBackgroundColor
        leftBackgroundView.round(corners: [.topLeft, .bottomLeft], radius: cornerRadius)
        leftBackgroundView.bringSubview(toFront: leftImageView)
        
        // style ImageView
        leftImageView.image = leftIcon
        leftImageView.frame = CGRect(origin: leftBackgroundView.center, size: CGSize(width: iconSize, height: iconSize))
        leftImageView.center = leftBackgroundView.center
        
        // style pathLabel
        pathLabel.textColor = textColor
        pathLabel.font = UIFont.defaultFontRegular(size: textSize)
        pathLabel.text = "Select path..."
        pathLabel.frame = CGRect(x: self.frame.height + leftTextSpace, y: 0, width: self.frame.width - self.frame.height - leftTextSpace, height: self.frame.height)
        
    }
    
    func selectPath(sender:UITapGestureRecognizer) {
        _selectedPath = self.selectPathDelegate.selectPath()
        pathLabel.text = _selectedPath?.filePath.relativePath
    }
    
}
