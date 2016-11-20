//
//  AquireViewController.swift
//  Spectrometer
//
//  Created by raphi on 19.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit
import Charts

class AquireViewController: UIViewController {
    
    @IBOutlet var lineChart: SpectrumLineChartView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func aquire() -> Void {
        let tcpManager: TcpManager = appDelegate.tcpManager!
        let command:Command = Command(commandParam: CommandEnum.Aquire, params: "1,10")
        let data = tcpManager.sendCommand(command: command)
        let spectrumParser = FullRangeInterpolatedSpectrumParser(data: data)
        let spectrum = spectrumParser.parse()
        updateChart(data: spectrum.getChartData())
    }
    
    func updateChart(data: LineChartData) -> Void {
        
        lineChart.data = data
        
    }
    @IBAction func testAquire(_ sender: Any) {
        
        aquire()
        
    }
    @IBAction func openShutter(_ sender: Any) {
        let tcpManager: TcpManager = appDelegate.tcpManager!
        let command:Command = Command(commandParam: CommandEnum.Aquire, params: "5,0")
        _ = tcpManager.sendCommand(command: command)
        
    }
    
    @IBAction func closeShutter(_ sender: Any) {
        let tcpManager: TcpManager = appDelegate.tcpManager!
        let command:Command = Command(commandParam: CommandEnum.Aquire, params: "5,1")
        _ = tcpManager.sendCommand(command: command)
        
    }
    
    
}
