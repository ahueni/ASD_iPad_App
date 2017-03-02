//
//  SpectrometerConfigTableViewCell.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 07.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class SpectrometerConfigTableViewCell : UITableViewCell {
    
    @IBOutlet var borderView: UIRoundBorderedView!
    @IBOutlet var name: UILabel!
    @IBOutlet var ipAdress: UILabel!
    @IBOutlet var port: UILabel!
    @IBOutlet var connectButton: UIColorButton!
    @IBOutlet var spectrometerImageView: UIImageView! {
        didSet {
            let ceruleanBlue = UIColor(red:0.00, green:0.61, blue:0.92, alpha:1.00)
            let imageViewSize = spectrometerImageView.layer.frame.size
            spectrometerImageView.image = UIImage.fontAwesomeIcon(name: .hddO, textColor: ceruleanBlue, size: imageViewSize)
            
        }
    }

}

class FiberOpticFileTableViewCell : UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var fileName: UILabel!
    @IBOutlet var removeButton: UIColorButton!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var backView: UIView!
    @IBOutlet var iconBackView: UIView!
    
    
}
