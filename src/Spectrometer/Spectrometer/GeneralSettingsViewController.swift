//
//  GeneralSettingsViewController.swift
//  Spectrometer
//
//  Created by raphi on 20.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class GeneralSettingsViewController: UIViewController {
    
    @IBAction func deleteAllUserSettingsPressed(_ sender: UIButton) {
        
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        
    }
    
    
}
