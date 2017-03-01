//
//  SpectrometerTabBarItem.swift
//  Spectrometer
//
//  Created by raphi on 01.03.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SpectrometerTabBarItem: UITabBarItem {
    
    @IBInspectable var icon: String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let iconImg:UIImage? = UIImage.fontAwesomeIcon(code: icon, textColor: .white, size: CGSize(width: 26, height: 26))
        if let image = iconImg {
            self.image = image
        } else {
            self.image = UIImage.fontAwesomeIcon(name: .squareO, textColor: .white, size: CGSize(width: 26, height: 26))
        }
        
    }
    
}
