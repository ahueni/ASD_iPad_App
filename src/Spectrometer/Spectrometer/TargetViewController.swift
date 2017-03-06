//
//  FastMeasurmentViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 22.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class TargetViewController : BaseMeasurementModal
{
    internal func update(percentageReceived: Int) {
        DispatchQueue.main.async {
            self.updateProgressBar(measurmentCount: percentageReceived, statusText: "Test", totalCount: 100)
        }
    }
    
    @IBOutlet var progressBar: CustomProgressBar!
    @IBOutlet var startMeasurementButton: LoadingButton!
    @IBOutlet var nextButton: UIBlueButton!
    var targetPage : TargetPage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        targetPage = pageContainer.currentPage as! TargetPage
        self.progressBar.initialize(total: self.targetPage.targetCount)
    }
    
    @IBAction func StartMeasurmentsButtonClicked(_ sender: UIButton) {
        ViewStore.sharedInstance.cancelMeasurment = false
        startMeasureLoop()
    }
    
    override func updateLineChart() {
        super.updateLineChart()
        if(pageContainer.measurmentMode == MeasurementMode.Reflectance)
        {
            DispatchQueue.main.async {
                self.MeasurementLineChart.setAxisValues(min: 0, max: MeasurementMode.Raw.rawValue)
            }
        }
    }
    
    func startMeasureLoop()
    {
        startMeasurementButton.showLoading()
        DispatchQueue.global().async {
            for i in 0...self.targetPage.targetCount-1
            {
                if(ViewStore.sharedInstance.cancelMeasurment)
                {
                    return
                }
                
                // Update progress
                self.updateProgressBar(measurmentCount: i, statusText: "Measure...", totalCount: self.targetPage.targetCount)
                
                // Measure
                let sampleCount = ViewStore.sharedInstance.instrumentConfiguration.sampleCount
                var spectrum = CommandManager.sharedInstance.aquire(samples: sampleCount)
                //DC Correction
                if(self.targetPage.takeDarkCurrent)
                {
                    spectrum = SpectrumCalculator.calculateDarkCurrentCorrection(spectrum: spectrum)
                }
                
                //Queue write of file
                
                
                switch self.pageContainer.measurmentMode! {
                case .Raw:
                        self.writeRawFileAsync(spectrum: spectrum, dataType: .RawType)
                case MeasurementMode.Reflectance:
                    self.writeReflectanceFileAsync(spectrum: spectrum, whiteRefrenceSpectrum: self.pageContainer.reflectanceWhiteReference, dataType: .RefType)
                case MeasurementMode.Radiance:
                    self.writeRadianceFilesAsync(spectrums: [spectrum], dataType: .RadType, isWhiteReference: false)
                }
                
                //calculate for display and show
                let caluclatedSpectrumBuffer = self.calculateSpectrum(spectrum: spectrum)
                self.pageContainer.spectrumList.append(spectrum)
                self.lineChartDataContainer.currentLineChart = caluclatedSpectrumBuffer.getChartData(lineWidth: 1)
                self.updateLineChart()
                
                // update progress & wait delay
                self.updateProgressBar(measurmentCount: i+1, statusText: "Waiting...", totalCount: self.targetPage.targetCount)
                sleep(UInt32(self.targetPage.targetDelay))
            }
            self.finishMeasurement()
        }
    }
    
    func calculateSpectrum(spectrum : FullRangeInterpolatedSpectrum) -> [Float]
    {
        if(self.pageContainer.measurmentMode == MeasurementMode.Radiance)
        {
            return SpectrumCalculator.calculateRadiance(spectrum: spectrum)
        }
        return spectrum.spectrumBuffer
    }
    
    func finishMeasurement() {
        
        DispatchQueue.main.async {
            self.startMeasurementButton.hideLoading()
            self.startMeasurementButton.setTitle("All measurments are done", for: .application)
            self.startMeasurementButton.isEnabled = false
            self.nextButton.isEnabled = true
            self.goToNextPage()
        }
        
    }
    
    func updateProgressBar(measurmentCount:Int, statusText:String, totalCount : Int)
    {
        DispatchQueue.main.async {
            self.progressBar.updateProgressBar(actual: measurmentCount, statusText: statusText)
        }
    }
    
}
