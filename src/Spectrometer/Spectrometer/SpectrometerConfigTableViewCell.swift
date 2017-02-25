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
    
    @IBOutlet var name: UILabel!
    @IBOutlet var ipAndPort: UILabel!
    @IBOutlet var connectButton: UIButton!
    @IBOutlet weak var spectrometerImageView: UIImageView!

}

class FiberOpticFileTableViewCell : UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var fileName: UILabel!
    @IBOutlet var removeButton: UIColorButton!
    @IBOutlet var iconImage: UIImageView!
    @IBOutlet var backView: UIView!
    @IBOutlet var iconBackView: UIView!
    
    
}
