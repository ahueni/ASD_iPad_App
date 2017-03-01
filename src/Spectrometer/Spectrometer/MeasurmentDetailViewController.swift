//
//  MeasurmentDetailViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 24.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit
import Charts

class MeasurmentDetailViewController: UIViewController {
    
    @IBOutlet weak var reflectanceButton: UIButton!
    
    @IBOutlet weak var radianceButton: UIButton!
    
    @IBOutlet var MeasurementLineChart: SpectrumLineChartView!
    var url : URL? = nil
    var spectralFile : SpectralFileV8!
    
    @IBAction func rawButtonClicked(_ sender: UIButton) {
    }
    
    @IBAction func reflectanceButtonClicked(_ sender: UIButton) {
        let calculatedSpectrum = SpectrumCalculator.calculateReflectanceFromFile(spectrumFile: spectralFile)
        self.MeasurementLineChart.setAxisValues(min: 0, max: MeasurementMode.Reflectance.rawValue)
        
        var values: [ChartDataEntry] = []
        for i in 0...calculatedSpectrum.count-1 {
            //print(spectrumBuffer[i])
            values.append(ChartDataEntry(x: Double(i+350), y: Double(calculatedSpectrum[i])))
        }
        self.MeasurementLineChart.data = LineChartData(dataSet: SpectrumLineChartDataSet(values: values, label: "-"))
    }
    
    @IBAction func radianceButtonClicked(_ sender: UIButton) {
        let calculatedSpectrum = SpectrumCalculator.calculateRadianceFromFile(spectralFile: spectralFile)
        self.MeasurementLineChart.setAxisValues(min: 0, max: MeasurementMode.Radiance.rawValue)
        
        var values: [ChartDataEntry] = []
        for i in 0...calculatedSpectrum.count-1 {
            //print(spectrumBuffer[i])
            values.append(ChartDataEntry(x: Double(i+350), y: Double(calculatedSpectrum[i])))
        }
        self.MeasurementLineChart.data = LineChartData(dataSet: SpectrumLineChartDataSet(values: values, label: "-"))
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reflectanceButton.isEnabled = true
        radianceButton.isEnabled = true

        if(url == nil)
        {
            return
        }
        spectralFile = parseSpectralFile(filePath: (url?.relativePath)!) as! SpectralFileV8!
        
        self.MeasurementLineChart.noDataText = "Es wurden noch keine Datei ausgewählt um im Diagramm dargestellt zu werden. Wählen Sie in der Ordnerstruktur eine Datei aus um diese als Diagramm anzuzeigen."
        self.MeasurementLineChart.setAxisValues(min: 0, max: 65000)
        self.MeasurementLineChart.data = spectralFile?.getChartData()
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
