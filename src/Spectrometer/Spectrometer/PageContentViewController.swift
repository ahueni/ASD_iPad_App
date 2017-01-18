//
//  PageContentViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 18.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class PageContentViewController : TestSeriesViewController{
    
    
    @IBOutlet weak var MeasurementLineChart: SpectrumLineChartView!
    @IBOutlet weak var PageLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let tcpManager: TcpManager = (UIApplication.shared.delegate as! AppDelegate).tcpManager!
    var spectrum :FullRangeInterpolatedSpectrum? = nil
    
    override func viewDidLoad()
    {
       	super.viewDidLoad()
        
        PageLabel.text = strTitle
        
    }
    @IBAction func startMeasurementClicked(_ sender: UIButton) {
        
        spectrum = aquire(samples: 10)
        
        MeasurementLineChart.setAxisValues(min: 0, max: 65000)
        MeasurementLineChart.data = spectrum?.getChartData()
    }
    
    
    func aquire(samples: Int32) -> FullRangeInterpolatedSpectrum {
        let serialQueue = DispatchQueue(label: "test")
        var spectrumParser :FullRangeInterpolatedSpectrumParser? = nil
        print("queue starts")
        serialQueue.sync {
            let command:Command = Command(commandParam: CommandEnum.Aquire, params: "1," + samples.description)
            let data = tcpManager.sendCommand(command: command)
            spectrumParser = FullRangeInterpolatedSpectrumParser(data: data)
            print("queue finished")
        }
        print("return aquire")
        return spectrumParser!.parse()
    }
    
    override func goToNextPage() {
        pageContainer?.goToNextPage(spectrum: spectrum!)
    }
}
