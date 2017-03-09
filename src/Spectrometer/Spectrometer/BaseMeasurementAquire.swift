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
    
    var stopAquire = false
    var aquireMeasurmentPage : AquireMeasurmentPage!
    
    var takenMeasurements: Int = 0 {
        didSet {
            if takenMeasurements >= aquireMeasurmentPage.aquireCount {
                self.isTakeingMeasurements = false
            }
        }
    }
    
    var isTakeingMeasurements: Bool = false
    
    @IBAction func startMeasurement(_ sender: LoadingButton) {
        startMesurement()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aquireMeasurmentPage = pageContainer.currentPage as! AquireMeasurmentPage
        
        progressBar?.initialize(total: aquireMeasurmentPage.aquireCount)
        
        // start aquire data
        ViewStore.sharedInstance.cancelMeasurment = false
        DispatchQueue.global().async {
            while(!ViewStore.sharedInstance.cancelMeasurment && !self.stopAquire){
                self.aquire()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stopAquire = true
    }
    
    private func aquire() {
        
        // aquire
        let sampleCount = ViewStore.sharedInstance.instrumentConfiguration.sampleCount
        let aquiredSpectrum = CommandManager.sharedInstance.aquire(samples: sampleCount)
        
        // DC Correction
        let currentSpectrum = SpectrumCalculator.calculateDarkCurrentCorrection(spectrum: aquiredSpectrum)
        
        // additional calculations only for chart
        let viewdata = additionalCalculationOnCurrentSpectrum(currentSpectrum: currentSpectrum)
        
        // counter nicht angekommen
        // -> daten abzweigen und zu messungen speichern
        // target: save call & clear pool
        if isTakeingMeasurements {
            handleRawSpectrum(currentSpectrum: currentSpectrum)
            handleChartData(chartData: viewdata)
            takenMeasurements += 1
        }
        
        lineChartDataContainer.currentLineChart = viewdata.getChartData(lineWidth: 1)
        
        //update Chart
        self.updateLineChart()
        
    }
    
    func startMesurement() {
        startMeasurement.showLoading()
        nextButton.isEnabled = false
        lineChartDataContainer.lineChartPool.removeAll()
    }
    
    func handleRawSpectrum(currentSpectrum: FullRangeInterpolatedSpectrum) {
        fatalError("must override")
    }
    
    func additionalCalculationOnCurrentSpectrum(currentSpectrum: FullRangeInterpolatedSpectrum) -> [Float] {
        fatalError("must override")
    }
    
    func handleChartData(chartData: [Float]) -> Void {
        fatalError("must override")
    }
    
    func updateLineChart(){
        DispatchQueue.main.async {
            //update ui
            self.MeasurementLineChart.setAxisValues(min: 0, max: self.pageContainer.measurmentMode.rawValue)
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
