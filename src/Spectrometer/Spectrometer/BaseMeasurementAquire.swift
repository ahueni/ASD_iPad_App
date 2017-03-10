//
//  MeasurementAquireBase.swift
//  Spectrometer
//
//  Created by raphi on 09.03.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import Charts

class MeasurementAquireBase: BaseMeasurementModal {
    
    var lineChartDataContainer : LineChartDataContainer! = LineChartDataContainer()
    
    @IBOutlet var startMeasurement: LoadingButton!
    @IBOutlet var progressBar: CustomProgressBar!
    @IBOutlet var MeasurementLineChart: SpectrumLineChartView!
    
    // indicator to stop aquire loop - on cancel - on view disappear
    var stopAquire = false
    
    // actual aquire page, target count and delay settings stored there
    var aquireMeasurmentPage : AquireMeasurmentPage!
    
    // indicator if raw data will branched to write file or to temp store
    // when activ -> measurements will be taken from aquire loop
    var isTakeingMeasurements: Bool = false
    
    // indicator how many measurements already taken, if count is reached
    // it will finish aquiring measurements and handle ui with finishedMeasurements
    var takenMeasurements: Int = 0 {
        didSet {
            if takenMeasurements >= aquireMeasurmentPage.aquireCount {
                self.isTakeingMeasurements = false
                finishedMeasurement()
            }
        }
    }
    
    // indicator how chart axis will be set on update
    var chartDisplayMode: MeasurementMode = MeasurementMode.Raw
    
    // button action to start measurements
    @IBAction func startMeasurement(_ sender: LoadingButton) {
        startMesurement()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // take measurement page to have settings values
        aquireMeasurmentPage = pageContainer.currentPage as! AquireMeasurmentPage
        
        // initialize progress bar if available
        progressBar?.initialize(total: aquireMeasurmentPage.aquireCount)
        
        // start aquire loop
        self.startAquire()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stopAquire = true
    }
    
    private func startAquire() {
        
        // start aquire data
        ViewStore.sharedInstance.cancelMeasurment = false
        DispatchQueue.global().async {
            while(!ViewStore.sharedInstance.cancelMeasurment && !self.stopAquire){
                
                // aquire new spectrum
                let sampleCount = ViewStore.sharedInstance.instrumentConfiguration.sampleCount
                let aquiredSpectrum = CommandManager.sharedInstance.aquire(samples: sampleCount)
                
                // DC correction
                let currentSpectrum = SpectrumCalculator.calculateDarkCurrentCorrection(spectrum: aquiredSpectrum)
                
                // additional calculations only for chart
                let chartData = self.viewCalculationsOnCurrentSpectrum(currentSpectrum: currentSpectrum)
                
                // handle rawData and chartView only when taking measurements is active 
                if self.isTakeingMeasurements {
                    self.handleRawSpectrum(currentSpectrum: currentSpectrum)
                    self.handleChartData(chartData: chartData)
                    self.takenMeasurements += 1
                    self.updateProgress(state: "Measured...")
                    print("took measurement " + self.takenMeasurements.description + " of " + self.aquireMeasurmentPage.aquireCount.description)
                }
                
                // put current line to chart and then update
                self.lineChartDataContainer.currentLineChart = chartData.getChartData(lineWidth: 1)
                self.updateLineChart()
            }
        }
    }
    
    func startMesurement() {
        takenMeasurements = 0
        startMeasurement.showLoading()
        startMeasurement.isEnabled = false
        nextButton.isEnabled = false
        lineChartDataContainer.lineChartPool.removeAll()
        isTakeingMeasurements = true
    }
    
    func finishedMeasurement() {
        DispatchQueue.main.async {
            self.startMeasurement.hideLoading()
            self.nextButton.isEnabled = true
            self.updateProgress(state: "Finished...")
        }
    }
    
    func handleRawSpectrum(currentSpectrum: FullRangeInterpolatedSpectrum) {
        fatalError("must override")
    }
    
    func viewCalculationsOnCurrentSpectrum(currentSpectrum: FullRangeInterpolatedSpectrum) -> [Float] {
        fatalError("must override")
    }
    
    func handleChartData(chartData: [Float]) -> Void {
        fatalError("must override")
    }
    
    private func updateProgress(state: String) -> Void {
        // switch to ui thread to update progress bar
        DispatchQueue.main.async {
            self.progressBar?.updateProgressBar(actual: self.takenMeasurements, statusText: state)
        }
    }
    
    private func updateLineChart(){
        // switch to ui thread to update line chart
        DispatchQueue.main.async {
            self.MeasurementLineChart.setAxisValues(min: 0, max: self.chartDisplayMode.rawValue)
            let lineChartDataSets = [self.lineChartDataContainer.currentLineChart] + self.lineChartDataContainer.lineChartPool
            self.MeasurementLineChart.data = LineChartData(dataSets: lineChartDataSets)
        }
    }
    
    func writeRawFileAsync(spectrum : FullRangeInterpolatedSpectrum, dataType: DataType)
    {
        DispatchQueue.global().async {
            FileWriteManager.sharedInstance.addToQueueRaw(spectrums: [spectrum], settings: self.pageContainer!.measurmentSettings)
        }
    }
    
    func writeReflectanceFileAsync(spectrum : FullRangeInterpolatedSpectrum, whiteRefrenceSpectrum: FullRangeInterpolatedSpectrum, dataType: DataType)
    {
        DispatchQueue.global().async {
            FileWriteManager.sharedInstance.addToQueueReflectance(spectrums: [spectrum], whiteRefrenceSpectrum: whiteRefrenceSpectrum, settings: self.pageContainer!.measurmentSettings)
        }
    }
    
    func writeRadianceFilesAsync(spectrums : [FullRangeInterpolatedSpectrum], dataType: DataType, isWhiteReference: Bool){
        DispatchQueue.global().async {
            let base = ViewStore.sharedInstance.instrumentConfiguration.base!
            let lamp = ViewStore.sharedInstance.instrumentConfiguration.lamp!
            let fiberOptic = InstrumentStore.sharedInstance.selectedForeOptic!
            let radianceCalibrationFiles = RadianceCalibrationFiles(baseFile: base, lampFile: lamp, fiberOptic: fiberOptic)
            
            let fileSuffix = isWhiteReference ? "_WR" : ""
            
            DispatchQueue.global().async {
                FileWriteManager.sharedInstance.addToQueueRadiance(spectrums: spectrums, radianceCalibrationFiles: radianceCalibrationFiles, settings: self.pageContainer!.measurmentSettings, fileSuffix: fileSuffix)
            }
        }
    }
    
}
