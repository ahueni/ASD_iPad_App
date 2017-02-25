//
//  SpectrumCalculator.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 25.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import Charts

class SpectrumCalculator{
    
    class func calculateDarkCurrentCorrection(spectrum : FullRangeInterpolatedSpectrum, darkCurrentSpectrum : FullRangeInterpolatedSpectrum) -> FullRangeInterpolatedSpectrum
    {
        
        let darkCorrectionRange = ((InstrumentSettingsCache.sharedInstance.endingWaveLength + 1) - InstrumentSettingsCache.sharedInstance.startingWaveLength)
        
        for i in 0...darkCorrectionRange{
            spectrum.spectrumBuffer[i] = spectrum.spectrumBuffer[i] - darkCurrentSpectrum.spectrumBuffer[i] + Float(InstrumentSettingsCache.sharedInstance.drift);
        }
        
        /*
         for (i, dVal) in darkCurrent.spectrumBuffer.enumerated() {
         let sVal = spectrumBuffer[i]
         let calculated = sVal - dVal + drift
         spectrumBuffer[i] = calculated
         }*/
        
        // Set darkCorrected flag in headers
        spectrum.spectrumHeader.vinirHeader.darkSubtracted = DarkSubtracted.Yes
        spectrum.spectrumHeader.swir1Header.darkSubtracted = DarkSubtracted.Yes
        spectrum.spectrumHeader.swir2Header.darkSubtracted = DarkSubtracted.Yes
        
        return spectrum
    }
    
    class func calculateReflectance(currentSpectrum : FullRangeInterpolatedSpectrum, whiteReferenceSpectrum : FullRangeInterpolatedSpectrum) -> [ChartDataEntry]
    {
        var values: [ChartDataEntry] = []
        for i in 0...whiteReferenceSpectrum.spectrumBuffer.count-1 {
            values.append(ChartDataEntry(x: Double(i+350), y: Double(currentSpectrum.spectrumBuffer[i] /  whiteReferenceSpectrum.spectrumBuffer[i] )))
        }
        return values
    }
    
    class func calculateRadiance(){
        
    }
    
}
