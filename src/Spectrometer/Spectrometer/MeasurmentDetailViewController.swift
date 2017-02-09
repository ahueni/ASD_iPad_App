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
    
    @IBOutlet var MeasurementLineChart: SpectrumLineChartView!
    var url : URL? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if(url == nil)
        {
            return
        }
        let spectrum = parseSpectralFile(filePath: (url?.relativePath)!)
        
        self.MeasurementLineChart.noDataText = "Es wurden noch keine Datei ausgewählt um im Diagramm dargestellt zu werden. Wählen Sie in der Ordnerstruktur eine Datei aus um diese als Diagramm anzuzeigen."
        self.MeasurementLineChart.setAxisValues(min: 0, max: 65000)
        self.MeasurementLineChart.data = spectrum?.getChartData()
    }
    
    private func parseSpectralFile(filePath: String) -> SpectralFileBase? {
        
        let fileManager = FileManager()
        let dataBuffer = [UInt8](fileManager.contents(atPath: filePath)!)
        let fileParser = IndicoAsdFileReader(data: dataBuffer)
        
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

}
