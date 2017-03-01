//
//  CustomizeExtensions.swift
//  Spectrometer
//
//  Created by raphi on 23.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    class func defaultFontRegular(size : CGFloat) -> UIFont {
        return UIFont(name: "Open Sans", size: size)!
    }
    
    class func defaultFontBold(size : CGFloat) -> UIFont {
        return UIFont(name: "OpenSans-Bold", size: size)!
    }
    
}

class MyUITextView : UITextView {
    
    override func becomeFirstResponder() -> Bool {
        
        print("Test")
        return true
        
    }
    
    
}

extension Notification.Name {
    static let reloadSpectrometerConfig = Notification.Name("reloadSpectrometerConfig")
    static let darkCurrentTimer = Notification.Name("darkCurrentTimer")
    static let whiteReferenceTimer = Notification.Name("whiteReferenceTimer")
}


extension UIViewController {
    
    func showWarningMessage(title: String, message: String) -> Void {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
