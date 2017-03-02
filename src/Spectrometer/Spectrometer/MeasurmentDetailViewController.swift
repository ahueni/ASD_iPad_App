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
    
    @IBOutlet var rawButton: RadioButton!
    @IBOutlet var reflectanceButton: RadioButton!
    @IBOutlet var radianceButton: RadioButton!
    @IBOutlet var MeasurementLineChart: SpectrumLineChartView!
    
    var url : URL? = nil
    var spectralFile : SpectralFileV8!
    
    @IBAction func rawButtonClicked(_ sender: UIButton) {
        self.MeasurementLineChart.setAxisValues(min: 0, max: MeasurementMode.Raw.rawValue)
        let chartDataSet = spectralFile.spectrum.getChartData()
        self.MeasurementLineChart.data = LineChartData(dataSet: chartDataSet)
    }
    
    @IBAction func reflectanceButtonClicked(_ sender: UIButton) {
        self.MeasurementLineChart.setAxisValues(min: 0, max: MeasurementMode.Reflectance.rawValue)
        let calculatedSpectrum = SpectrumCalculator.calculateReflectanceFromFile(spectrumFile: spectralFile)
        let chartDataSet = calculatedSpectrum.getChartData(lineWidth: 1)
        self.MeasurementLineChart.data = LineChartData(dataSet: chartDataSet)
    }
    
    @IBAction func radianceButtonClicked(_ sender: UIButton) {
        self.MeasurementLineChart.setAxisValues(min: 0, max: MeasurementMode.Radiance.rawValue)
        let calculatedSpectrum = SpectrumCalculator.calculateRadianceFromFile(spectralFile: spectralFile)
        let chartDataSet = calculatedSpectrum.getChartData()
        self.MeasurementLineChart.data = LineChartData(dataSet: chartDataSet)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init radio buttons
        rawButton.alternateButton = [reflectanceButton, radianceButton]
        reflectanceButton.alternateButton = [rawButton, radianceButton]
        radianceButton.alternateButton = [rawButton, reflectanceButton]

        if let url = url {
            
            spectralFile = parseSpectralFile(filePath: url.relativePath) as! SpectralFileV8!
            
            switch spectralFile.dataType {
            case .RefType:
                reflectanceButton.isEnabled = true
            case .RadType:
                radianceButton.isEnabled = true
            default:
                break
            }
            
            rawButton.isEnabled = true
            rawButton.unselectAlternateButtons()
            self.rawButtonClicked(rawButton)
            
        }
        self.MeasurementLineChart.noDataText = "Please select a file..."
    }
    
    private func parseSpectralFile(filePath: String) -> SpectralFileBase? {
        let fileManager = FileManager()
        let dataBuffer = [UInt8](fileManager.contents(atPath: filePath)!)
        let fileParser = IndicoAsdFileReader(data: dataBuffer)
        
        var file: SpectralFileBase
        
        do {
            file = try fileParser.parse()
        } catch let error as ParsingError {
            self.showWarningMessage(title: "Error", message: error.message)
            return nil
        } catch {
            self.showWarningMessage(title: "File error", message: "Could not read file...")
            return nil
        }
        
        return file
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
