//
//  BaseMeasurementModal.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 27.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class BaseMeasurementModal : UIViewController
{
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var pageContainer : ParentViewController!
    
    @IBOutlet weak var MeasurementLineChart: SpectrumLineChartView!
    
    func goToNextPage() {
        pageContainer.goToNextPage()
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        goToNextPage()
    }
    
    @IBAction func CancelButtonClicked(_ sender: UIButton) {
        InstrumentSettingsCache.sharedInstance.cancelMeasurment = true
        dismiss(animated: true, completion: nil)
    }
    
    func updateLineChart(spectrum : FullRangeInterpolatedSpectrum){
        
        DispatchQueue.main.async {
            //update ui
            if(self.pageContainer.measurmentMode == MeasurementMode.Radiance)
            {
                self.MeasurementLineChart.setAxisValues(min: 0, max: MeasurementMode.Radiance.rawValue)
                let radianceSpectrumBuffer = SpectrumCalculator.calculateRadiance(spectrum: spectrum)
                self.MeasurementLineChart.data = radianceSpectrumBuffer.getChartData()
            }
            else{
                self.MeasurementLineChart.setAxisValues(min: 0, max: MeasurementMode.Raw.rawValue)
                self.MeasurementLineChart.data = spectrum.getChartData()
            }
        }
    }
    
    func writeFileAsync(spectrums : [FullRangeInterpolatedSpectrum], isWhiteReference :Bool, dataType: DataType)
    {
        DispatchQueue.global().async {
            var indicoCalibration : IndicoCalibration? = nil
            if(self.pageContainer.measurmentMode == MeasurementMode.Radiance)
            {
                let base = InstrumentSettingsCache.sharedInstance.instrumentConfiguration.base!
                let lamp = InstrumentSettingsCache.sharedInstance.instrumentConfiguration.lamp!
                let fiberOptic = InstrumentSettingsCache.sharedInstance.selectedForeOptic!
                indicoCalibration = IndicoCalibration(baseFile: base, lampFile: lamp, fiberOptic: fiberOptic)
            }
            
            let fileSuffix = isWhiteReference ? "_WR" : ""
            
            BackgroundFileWriteManager.sharedInstance.addToQueue(spectrums: spectrums, whiteRefrenceSpectrum: nil, loadedSettings: self.pageContainer!.measurmentSettings, dataType: dataType, indicoCalibration: indicoCalibration, fileSuffix: fileSuffix)
        }
    }
    
    func writeFileAsync(spectrum : FullRangeInterpolatedSpectrum, isWhiteReference :Bool, dataType: DataType){
        var spectrums : [FullRangeInterpolatedSpectrum] = [FullRangeInterpolatedSpectrum]()
        spectrums.append(spectrum)
        writeFileAsync(spectrums : spectrums, isWhiteReference: isWhiteReference, dataType: dataType)
    }
}
