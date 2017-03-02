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

protocol BaseSelectInputDelegate {
    func openFileBrowser(path:URL?, sender: BaseSelectInput)
    func didSelectPath()
}


class BaseSelectInput: UIView, BaseValidationControl {
    
    var delegate: BaseSelectInputDelegate!
    
    internal var _selectedPath:URL?
    var selectedPath:URL? { get { return _selectedPath } }
    
    var isValid: Bool {
        get {
            if let path = selectedPath {
                print("Validate: " + path.absoluteString)
                print("Result: " + path.exists().description)
                return path.exists()
            }
            return false
        }
    }
    
    var leftBackgroundView:UIView!
    var leftImageView:UIImageView!
    var leftIcon:UIImage!
    var pathLabel:UILabel!
    
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
    
    @IBInspectable var placeHolderText: String = "Select..." {
        didSet {
            pathLabel.text = placeHolderText
        }
    }
    
    @IBInspectable var textColor: UIColor = UIColor.clear {
        didSet {
            pathLabel.textColor = textColor.withAlphaComponent(0.75)
        }
    }
    
    @IBInspectable var textSize: CGFloat = 16 {
        didSet {
            pathLabel.font = UIFont.defaultFontRegular(size: textSize)
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
    
    @IBInspectable var iconSize: Int = 16 {
        didSet {
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
        
        pathLabel.text = placeHolderText
        pathLabel.textColor = textColor.withAlphaComponent(0.75)
        pathLabel.font = UIFont.defaultFontRegular(size: textSize)
        pathLabel.lineBreakMode = .byTruncatingHead
        
        self.addSubview(leftBackgroundView)
        self.addSubview(pathLabel)
        
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
        leftImageView.image = UIImage.fontAwesomeIcon(name: .folderOpenO, textColor: .white, size: CGSize(width: iconSize, height: iconSize))
        leftImageView.frame = CGRect(origin: leftBackgroundView.center, size: CGSize(width: iconSize, height: iconSize))
        leftImageView.center = leftBackgroundView.center
        
        // style pathLabel
        pathLabel.frame = CGRect(x: self.frame.height + leftTextSpace, y: 0, width: self.frame.width - self.frame.height - leftTextSpace, height: self.frame.height)
        
    }
    
    func selectPath(sender:UITapGestureRecognizer) {
        self.delegate.openFileBrowser(path: selectedPath, sender: self)
    }
    
    func update(selectedPath: URL) {
        _selectedPath = selectedPath
        validate()
        updateFilePathLabel()
        self.delegate.didSelectPath()
    }
    
    func updateFilePathLabel()
    {
        if isValid {
            let rootPath = InstrumentSettingsCache.sharedInstance.measurementsRoot
            pathLabel.text = self.selectedPath!.getDisplayPathFromRoot(rootPath: rootPath)
        }
    }
    
    func validate() {
        
        if isValid {
            pathLabel.textColor = textColor
        } else {
            pathLabel.textColor = UIColor.red
        }
        
    }
    
}
