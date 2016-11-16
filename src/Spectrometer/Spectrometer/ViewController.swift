//
//  ViewController.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func sendCCommand(_ sender: Any) {
        
        let command:Command = Command(commandParam: CommandEnum.Aquire, params: "1,40")
        let aquire:FullRangeInterpolatedSpectrum = appDelegate.tcpManager?.sendCommand(command: command) as! FullRangeInterpolatedSpectrum
        
        print("Header: "+aquire.spectrumHeader.header.rawValue.description)
        
    }

    @IBAction func sendVersionCommand(_ sender: Any) {
        
        let command:Command = Command(commandParam: CommandEnum.Version, params: "")
        let version:Version = appDelegate.tcpManager?.sendCommand(command: command) as! Version
        
        print("Header: "+version.header.rawValue.description)
        
        
    }
}

