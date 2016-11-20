//
//  ViewController.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import UIKit

class ConnectionViewController: UIViewController {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func connectDevice(_ sender: Any) {
        
        let tcpManager: TcpManager = TcpManager(hostname: "10.1.1.77", port: 8080)
        
        if (!tcpManager.connect()) {
            let alert = UIAlertController(title: "Verbindung fehlgeschlagen", message: "Es konnte keine Verbindung mit dem Spektrometer hergestellt werden. Überprüfen sie die Einstellungen und ob das Gerät mit dem Netzwerk des Spektrometers verbunden ist.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            
            _ = tcpManager.sendCommand(command: Command(commandParam: CommandEnum.Restore, params: ""))
            
            appDelegate.tcpManager = tcpManager
            
            let initialViewController = self.storyboard?.instantiateViewController(withIdentifier: "SpektrometerApp") as! UITabBarController
            
            appDelegate.window?.rootViewController = initialViewController
            appDelegate.window?.makeKeyAndVisible()
            
        }
        
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

