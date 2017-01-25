//
//  ViewController.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import UIKit

class ConnectionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let dataViewContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var configs: [SpectrometerConfig] = []
    
    @IBOutlet var deviceTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadData), name: .reloadSpectrometerConfig, object: nil)
        deviceTableView.delegate = self
        deviceTableView.dataSource = self        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //deviceTableView.layer.cornerRadius = 15
        deviceTableView.layer.masksToBounds = true
        
        reloadData()
    }
    
    func reloadData() -> Void {
        do {
            self.configs = try dataViewContext.fetch(SpectrometerConfig.fetchRequest())
        } catch {
            print("could not load spectrometers")
        }
        
        
        
        deviceTableView.reloadData()
    }
    
    func connectDevice(sender: UIButton) -> Void {
             
        let alert = UIAlertController(title: nil, message: "Verbinden...", preferredStyle: .alert)
        let acitivty = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = acitivty
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        
        let config = self.configs[sender.tag]
        let tcpManager: TcpManager = TcpManager(hostname: config.ipAdress!, port: Int(config.port))
        
        present(alert, animated: false, completion: nil)
        
        
        // connect with background thread
        DispatchQueue.global(qos: .background).async {
            
            if (tcpManager.connect()) {
                alert.dismiss(animated: true, completion: nil)
                self.displayMainPage(tcpManager: tcpManager, config: config)
            } else {
                alert.dismiss(animated: true, completion: {
                    self.showWarningMessage(title: "Verbindung fehlgeschlagen", message: "Es konnte keine Verbindung mit dem Spektrometer hergestellt werden. Überprüfen sie die Einstellungen und ob das Gerät mit dem Netzwerk des Spektrometers verbunden ist.")
                })
            }
            
        }
        
        
        
    }
    
    func displayMainPage(tcpManager: TcpManager, config : SpectrometerConfig) -> Void {
        
        DispatchQueue.main.sync {
            _ = tcpManager.sendCommand(command: Command(commandParam: CommandEnum.Restore, params: "1"))
            self.appDelegate.tcpManager = tcpManager
            self.appDelegate.config = config
            
            let initialViewController = self.storyboard?.instantiateViewController(withIdentifier: "SpektrometerApp") as! UITabBarController
            self.appDelegate.window?.rootViewController = initialViewController
            self.appDelegate.window?.makeKeyAndVisible()
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return configs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let config = configs[indexPath.row]
        
        let cell = deviceTableView.dequeueReusableCell(withIdentifier: "Cell") as! SpectrometerConfigTableViewCell
        
        cell.name.text = config.name
        cell.ipAndPort.text = "Ip: " + config.ipAdress! + " / Port: " + config.port.description
        cell.connectButton.tag = indexPath.row
        cell.connectButton.addTarget(self, action: #selector(self.connectDevice(sender:)), for: .touchUpInside)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Bearbeiten", handler:{action, indexpath in
            let config: SpectrometerConfig = self.configs[indexpath.row]
            //print(config.illSpectrum as! [Double])
            
            let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditConnection") as! AddEditConnectionViewController
            modalViewController.setConfigData(config: config)
            modalViewController.modalPresentationStyle = .formSheet
            self.present(modalViewController, animated: true, completion: nil)
            
        });
        
        editRowAction.backgroundColor = UIColor.green
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Löschen", handler:{action, indexpath in
            let config: SpectrometerConfig = self.configs[indexpath.row]
            self.dataViewContext.delete(config)
            
            do {
                try self.dataViewContext.save()
            } catch {
                print("Cant delete")
            }
            self.reloadData()
            
        });
        
        return [deleteRowAction, editRowAction];
        
    }
    
}

