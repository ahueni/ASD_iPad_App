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
    var spectralFile : IndicoFile7!
    
    @IBAction func rawButtonClicked(_ sender: UIButton) {
        self.MeasurementLineChart.setAxisValues(mode: MeasurementMode.Raw)
        let chartDataSet = spectralFile.spectrum.getChartData()
        self.MeasurementLineChart.data = LineChartData(dataSet: chartDataSet)
        ViewStore.sharedInstance.lastViewMode = .Raw
    }
    
    @IBAction func reflectanceButtonClicked(_ sender: UIButton) {
        self.MeasurementLineChart.setAxisValues(mode: MeasurementMode.Reflectance)
        let calculatedSpectrum = SpectrumCalculator.calculateReflectanceFromFile(spectrumFile: spectralFile)
        let chartDataSet = calculatedSpectrum.getChartData(lineWidth: 1)
        self.MeasurementLineChart.data = LineChartData(dataSet: chartDataSet)
        ViewStore.sharedInstance.lastViewMode = .Reflectance
    }
    
    @IBAction func radianceButtonClicked(_ sender: UIButton) {
        self.MeasurementLineChart.setAxisValues(mode: MeasurementMode.Radiance)
        let calculatedSpectrum = SpectrumCalculator.calculateRadianceFromFile(spectralFile: spectralFile)
        let chartDataSet = calculatedSpectrum.getChartData()
        self.MeasurementLineChart.data = LineChartData(dataSet: chartDataSet)
        ViewStore.sharedInstance.lastViewMode = .Radiance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init radio buttons
        rawButton.alternateButton = [reflectanceButton, radianceButton]
        reflectanceButton.alternateButton = [rawButton, radianceButton]
        radianceButton.alternateButton = [rawButton, reflectanceButton]
        
        if let url = url {
            
            spectralFile = parseSpectralFile(filePath: url.relativePath) as! IndicoFile7!
            
            switch spectralFile.dataType {
            case .RefType:
                reflectanceButton.isEnabled = true
                radianceButton.isEnabled = false
            case .RadType:
                radianceButton.isEnabled = true
                reflectanceButton.isEnabled = false
            default:
                reflectanceButton.isEnabled = false
                radianceButton.isEnabled = false
            }
            
            rawButton.isEnabled = true
            
            // choose last state if possible otherwise switch to raw
            switch ViewStore.sharedInstance.lastViewMode {
            case .Raw:
                rawButton.unselectAlternateButtons()
                self.rawButtonClicked(rawButton)
            case .Reflectance:
                if spectralFile.dataType == .RefType {
                    reflectanceButton.unselectAlternateButtons()
                    self.reflectanceButtonClicked(reflectanceButton)
                } else {
                    rawButton.unselectAlternateButtons()
                    self.rawButtonClicked(rawButton)
                }
            case .Radiance:
                if spectralFile.dataType == .RadType {
                    radianceButton.unselectAlternateButtons()
                    self.radianceButtonClicked(radianceButton)
                } else {
                    rawButton.unselectAlternateButtons()
                    self.rawButtonClicked(rawButton)
                }
            }
            
            
        } else {
            self.MeasurementLineChart.noDataText = "Please select a file..."
        }
    }
    
    private func parseSpectralFile(filePath: String) -> IndicoFileBase? {
        let fileManager = FileManager()
        let dataBuffer = [UInt8](fileManager.contents(atPath: filePath)!)
        let fileParser = IndicoAsdFileReader(data: dataBuffer)
        
        var file: IndicoFileBase
        
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
