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
        
        let tcpManager: TcpManager = appDelegate.tcpManager!
        
        let command:Command = Command(commandParam: CommandEnum.Aquire, params: "1,10")
        let data = tcpManager.sendCommand(command: command)
        let spectrumParser = FullRangeInterpolatedSpectrumParser(data: data)
        let spectrum = spectrumParser.parse()
        
        print(spectrum.spectrumBuffer)
        
        print(spectrum)
        
    }

    @IBAction func sendVersionCommand(_ sender: Any) {
        
        let tcpManager: TcpManager = appDelegate.tcpManager!
        
        let command:Command = Command(commandParam: CommandEnum.Version, params: "")
        let data = tcpManager.sendCommand(command: command)
        let versionParser = VersionParser(data: data)
        let version = versionParser.parse()
        
        print("Header: "+version.header.rawValue.description)
        print("Error: "+version.error.rawValue.description)
        print("Version: "+version.version)
        print("Version: "+version.versionNumber.description)
        print("Type: "+version.type.rawValue.description)
        
        
    }
}

