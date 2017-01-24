//
//  MeasurmentDetailViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 24.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class MeasurmentDetailViewController: UIViewController {
    
    @IBOutlet weak var MeasurementLineChart: SpectrumLineChartView!
    @IBOutlet weak var testLabel: UILabel!
    var url : URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(url == nil)
        {
            return
        }
        // Do any additional setup after loading the view.
        testLabel.text = url?.absoluteString
        
        
        var spectrum = parseSpectralFile(filePath: (url?.relativePath)!)
        spectrum?.spectrum
        
        self.MeasurementLineChart.setAxisValues(min: 0, max: 65000)
        self.MeasurementLineChart.data = spectrum?.getChartData()
    }
    
    private func parseSpectralFile(filePath: String) -> SpectralFileBase? {
        
        var fileManager = FileManager()
        let dataBuffer = [UInt8](fileManager.contents(atPath: filePath)!)
        let fileParser = SpectralFileParser(data: dataBuffer)
        var file: SpectralFileBase
        
        do {
            file = try fileParser.parse()
        } catch let error as ParsingError {
            self.showWarningMessage(title: "Fehler", message: error.message)
            return nil
        } catch {
            self.showWarningMessage(title: "Dateifehler", message: "Die Datei konnte nicht gelesen werden.")
            return nil
        }
        
        return file
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
