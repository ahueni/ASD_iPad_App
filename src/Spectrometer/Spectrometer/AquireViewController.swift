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
    
    // buttons
    @IBOutlet var aquireButton: UIButton!
    
    // chart
    @IBOutlet var lineChart: SpectrumLineChartView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let tcpManager: TcpManager = (UIApplication.shared.delegate as! AppDelegate).tcpManager!
    var darkCurrentSpectrum: FullRangeInterpolatedSpectrum? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func testAquire(_ sender: Any) {
        let spectrum = aquire(samples: 25)
        spectrum.subtractDarkCurrent(darkCurrentBuffer: (darkCurrentSpectrum?.spectrumBuffer)!)
        updateChart(data: spectrum.getChartData())
    }
    
    @IBAction func darkCurrent(_ sender: Any) {
        closeShutter()
        darkCurrentSpectrum = aquire(samples: 25)
        openShutter()
        toggleButtons()
    }
    
    @IBAction func openShutter(_ sender: Any) {
        openShutter()
    }
    
    @IBAction func closeShutter(_ sender: Any) {
        closeShutter()
    }
    
    @IBAction func radiance(_ sender: Any) {
        
        print("radiance pressed")
        
        var number: [Int] = []
        
        while number.count < 6 {
            let num = arc4random_uniform(43)
            if num == 0 { continue }
            if number.contains(Int(num)) { continue }
            number.append(Int(num))
        }
        
        number.sort()
        
        var star = 0
        
        while star == 0 {
            star = Int(arc4random_uniform(7))
        }
        
        
        
        print(number)
        print(star)
        
        
        
    }
    
    
    func aquire(samples: Int) -> FullRangeInterpolatedSpectrum {
        //let tcpManager: TcpManager = appDelegate.tcpManager!
        let command:Command = Command(commandParam: CommandEnum.Aquire, params: "1," + samples.description)
        let data = tcpManager.sendCommand(command: command)
        let spectrumParser = FullRangeInterpolatedSpectrumParser(data: data)
        return spectrumParser.parse()
    }
    
    func closeShutter() -> Void {
        //let tcpManager: TcpManager = appDelegate.tcpManager!
        let command:Command = Command(commandParam: CommandEnum.Aquire, params: "5,1")
        _ = tcpManager.sendCommand(command: command)
    }
    
    func openShutter() -> Void {
        //let tcpManager: TcpManager = appDelegate.tcpManager!
        let command:Command = Command(commandParam: CommandEnum.Aquire, params: "5,0")
        _ = tcpManager.sendCommand(command: command)
    }
    
    func updateChart(data: LineChartData) -> Void {
        lineChart.data = data
    }
    
    func toggleButtons() -> Void {
        
        if darkCurrentSpectrum != nil {
            aquireButton.isEnabled = true
        } else {
            aquireButton.isEnabled = false
        }
        
    }
    
    
}
