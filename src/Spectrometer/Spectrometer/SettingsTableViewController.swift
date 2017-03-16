//
//  SettingsTableViewController.swift
//  Spectrometer
//
//  Created by raphi on 10.03.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet var general: UITableViewCell!
    @IBOutlet var instrumentConfiguration: UITableViewCell!
    @IBOutlet var instrumentControl: UITableViewCell!
    @IBOutlet var about: UITableViewCell!
    
    override func viewDidAppear(_ animated: Bool) {
        
        // hide instrument settings when not connected
        let spectrometerIsConnected = TcpManager.sharedInstance.isConnected
        
        instrumentConfiguration.isUserInteractionEnabled = spectrometerIsConnected
        instrumentConfiguration.alpha = spectrometerIsConnected ? 1.0 : 0.4
        
        instrumentControl.isUserInteractionEnabled = spectrometerIsConnected
        instrumentControl.alpha = spectrometerIsConnected ? 1.0 : 0.4
        
        
    }
    
}
