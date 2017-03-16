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
        let address = InternetAddress(hostname: config.ipAdress!, port: Port(config.port) )
        
        present(alert, animated: false, completion: {
        
            // connect in background thread
            DispatchQueue.global(qos: .userInitiated).async {
                
                // if connection successful display main page otherwise show warning message
                if (TcpManager.sharedInstance.connect(internetAdress: address)) {
                    
                    DispatchQueue.main.async {
                        alert.message = "Restore..."
                    }
                    
                    // first send a RESTORE command to initilaize spectrometer
                    CommandManager.sharedInstance.restore(successCallBack: {
                        
                        // second send a OPTIMIZE command
                        DispatchQueue.main.async {
                            alert.message = "Optimize..."
                        }
                        CommandManager.sharedInstance.optimize(successCallBack: {
                            
                            // then INITIALIZE app with instrument values
                            DispatchQueue.main.async {
                                alert.message = "Initialize..."
                            }
                            CommandManager.sharedInstance.initialize(successCallBack: {
                                
                                // set spectrometer config applicationwide
                                ViewStore.sharedInstance.instrumentConfiguration = config
                                
                                // after initialization set default foreoptic file - it will pre-calculate radiance values
                                // first check if bareFiber is available otherwise take the first of all files
                                let allForeOpticFiles = ViewStore.sharedInstance.instrumentConfiguration.fiberOpticCalibrations?.allObjects as! [CalibrationFile]
                                if let bareFiberFile = allForeOpticFiles.first(where: { $0.fo == 0 }) {
                                    InstrumentStore.sharedInstance.selectedForeOptic = bareFiberFile
                                } else {
                                    InstrumentStore.sharedInstance.selectedForeOptic = allForeOpticFiles.first
                                }
                                
                                
                                // close connecting alert and redirect to main page
                                alert.dismiss(animated: true, completion: nil)
                                self.displayMainPage()
                                
                            }, errorCallBack: { error in
                                self.cancelInitialization(error: error, alert: alert)
                            })
                            
                        }, errorCallBack: { error in
                            self.cancelInitialization(error: error, alert: alert)
                        })
                        
                    }, errorCallBack: { error in
                        self.cancelInitialization(error: error, alert: alert)
                    })
                } else {
                    alert.dismiss(animated: true, completion: {
                        self.showWarningMessage(title: "Connection failed", message: "The connection to the spectrometer could not be established. Please check your device settings and make sure you are connected to the same network as the spectrometer device.")
                    })
                }
                
            }
        
        })
        
    }
    
    func cancelInitialization(error: Error, alert: UIAlertController) {
        
        var errorMessage = "The connection to the spectrometer could not be established. Please check your device settings and make sure you are connected to the same network as the spectrometer device."
        if let error = error as? SpectrometerError {
            errorMessage = error.message
        }
        
        
        DispatchQueue.main.async {
            alert.dismiss(animated: true, completion: {
                self.showWarningMessage(title: "Error", message: errorMessage)
            })
        }
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
        
        let darkPastellGreen = UIColor(red:0.09, green:0.76, blue:0.28, alpha:1.00)
        
        let config = configs[indexPath.row]
        let cell = deviceTableView.dequeueReusableCell(withIdentifier: "Cell") as! SpectrometerConfigTableViewCell
        
        cell.name.text = config.name
        
        cell.ipAdress.text = config.ipAdress!.description
        cell.port.text = config.port.description
        
        cell.connectButton.tag = indexPath.row
        cell.connectButton.addTarget(self, action: #selector(self.connectDevice(sender:)), for: .touchUpInside)
        
        PlainPing.ping(config.ipAdress!, withTimeout: 1.0, completionBlock: { (timeElapsed:Double?, error:Error?) in
            
            if timeElapsed != nil {
                cell.name.textColor = darkPastellGreen
                cell.connectButton.background = darkPastellGreen
                let pulsator = Pulsator()
                pulsator.numPulse = 4
                pulsator.radius = 45
                pulsator.position = cell.spectrometerImageView.center
                cell.borderView.layer.insertSublayer(pulsator, at: 0)
                pulsator.start()
            }
            
            if let error = error {
                print("ping failed for " + config.ipAdress! + " | error: " + error.localizedDescription)
            }
            
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let editRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Edit", handler:{action, indexpath in
            let config: SpectrometerConfig = self.configs[indexpath.row]
            //print(config.illSpectrum as! [Double])
            
            let modalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddEditConnection") as! AddEditConnectionViewController
            modalViewController.initData(config: config)
            modalViewController.modalPresentationStyle = .formSheet
            self.present(modalViewController, animated: true, completion: nil)
            
        });
        
        editRowAction.backgroundColor = UIColor(red:0.09, green:0.76, blue:0.28, alpha:1.00)
        
        let deleteRowAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Delete", handler:{action, indexpath in
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

