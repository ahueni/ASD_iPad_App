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

extension UIViewController {
    
    func showWarningMessage(title: String, message: String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
