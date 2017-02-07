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
