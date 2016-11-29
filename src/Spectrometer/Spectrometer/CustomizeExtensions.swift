//
//  CustomizeExtensions.swift
//  Spectrometer
//
//  Created by raphi on 23.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class MyUITextView : UITextView {
    
    override func becomeFirstResponder() -> Bool {
        
        print("Test")
        return true
        
    }
    
    
}


class SpectrometerConfigTableViewCell : UITableViewCell {
    
    @IBOutlet var name: UILabel!
    @IBOutlet var ipAndPort: UILabel!
    
    
}
