//
//  ViewController.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import UIKit
import PlainPing
import Pulsator

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
        reloadData()
    }
    
    func reloadData() -> Void {
        do {
            self.configs = try dataViewContext.fetch(SpectrometerConfig.fetchRequest())
        } catch {
            self.showWarningMessage(title: "Warning", message: "Could not load spectrometer configs")
        }
        deviceTableView.reloadData()
    }
    
    func connectDevice(sender: UIButton) -> Void {
             
        let alert = UIAlertController(title: nil, message: "Connecting...", preferredStyle: .alert)
        let acitivty = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = acitivty
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        
        let config = self.configs[sender.tag]
        let adress = InternetAddress(hostname: config.ipAdress!, port: Port(Int(config.port)))
        
        present(alert, animated: false, completion: {
        
            // connect in background thread
            DispatchQueue.global(qos: .userInitiated).async {
                
                // if connection successful display main page otherwise show warning message
                if (TcpManager.sharedInstance.connect(internetAdress: adress)) {
                    
                    DispatchQueue.main.async {
                        alert.message = "Restore..."
                    }
                    
                    // set config to app delegate ->>>>> SHOULD BE IN A GLOBAL CACHE MANAGER
                    self.appDelegate.config = config
                    
                    // first send a RESTORE command to initilaize spectrometer
                    CommandManager.sharedInstance.restore()
                    
                    DispatchQueue.main.async {
                        alert.message = "Optimize..."
                    }
                    CommandManager.sharedInstance.optimize()
                    
                    DispatchQueue.main.async {
                        alert.message = "Initialize..."
                    }
                    // initialize app with defualt spectrometer values
                    CommandManager.sharedInstance.initialize()
                    
                    // pre calculate radiance values
                    let firstForeoptic = (config.fiberOpticCalibrations?.allObjects as! [CalibrationFile]).first
                    SpectrumCalculator.sharedInstance.updateForeopticFiles(base: config.base!, lamp: config.lamp!, foreoptic: firstForeoptic!)
                    
                    // close connecting alert and redirect to main page
                    alert.dismiss(animated: true, completion: nil)
                    self.displayMainPage()
                
                } else {
                    alert.dismiss(animated: true, completion: {
                        self.showWarningMessage(title: "Connection failed", message: "Es konnte keine Verbindung mit dem Spektrometer hergestellt werden. Überprüfen sie die Einstellungen und ob das Gerät mit dem Netzwerk des Spektrometers verbunden ist.")
                    })
                }
                
            }
        
        })
        
    }
    
    func displayMainPage() -> Void {
        
        DispatchQueue.main.async {
            // create viewcontroller and set it as new rootView controller
            let initialViewController = self.storyboard?.instantiateViewController(withIdentifier: "SpektrometerApp") as! UITabBarController
            self.appDelegate.window?.rootViewController = initialViewController
            self.appDelegate.window?.makeKeyAndVisible()
        }
        
    }
    
    // MARK - Spectrometer TableView configuration
    
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
        
        PlainPing.ping(config.ipAdress!, withTimeout: 1.0, completionBlock: { (timeElapsed:Double?, error:Error?) in
            
            if timeElapsed != nil {
                cell.name.textColor = .blue
                let pulsator = Pulsator()
                pulsator.numPulse = 4
                pulsator.radius = 45
                pulsator.position = cell.spectrometerImageView.center
                cell.contentView.layer.insertSublayer(pulsator, at: 0)
                pulsator.start()
            }
            
            if let error = error {
                print("ping failed for " + config.ipAdress! + " | error: " + error.localizedDescription)
            }
            
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Bearbeiten", handler:{action, indexpath in
            let config: SpectrometerConfig = self.configs[indexpath.row]
            //print(config.illSpectrum as! [Double])
            
            let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditConnection") as! AddEditConnectionViewController
            modalViewController.initData(config: config)
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
            self.reloadData()        });
        return [deleteRowAction, editRowAction];
    }
    
}

