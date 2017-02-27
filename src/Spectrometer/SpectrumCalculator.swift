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
    
    class func calculateDarkCurrentCorrection(spectrum : FullRangeInterpolatedSpectrum) -> FullRangeInterpolatedSpectrum
    {
        
        // if dc exists -> do darkcorrection
        if let darkCurrent = InstrumentSettingsCache.sharedInstance.darkCurrent {
            
            let vinirDarkCurrentCorrection: Float = Float(InstrumentSettingsCache.sharedInstance.vinirDarkCurrentCorrection)
            let currentDrift: Float = Float(spectrum.spectrumHeader.vinirHeader.drift)
            let darkDrift: Float = Float(darkCurrent.spectrumHeader.vinirHeader.drift)
            
            let drift: Float = vinirDarkCurrentCorrection + (currentDrift - darkDrift)
            print("CurrentDrift: " + currentDrift.description)
            print("DarkDrift: " + darkDrift.description)
            
            let vinirEndingWaveLength = InstrumentSettingsCache.sharedInstance.vinirEndingWavelength
            let vinirStartingWaveLength = InstrumentSettingsCache.sharedInstance.startingWaveLength
            
            let darkCorrectionRange = vinirEndingWaveLength + 1 - vinirStartingWaveLength
            print("DarkCorrectionRange: " + darkCorrectionRange.description)
            
            for i in 0...650{
                spectrum.spectrumBuffer[i] = spectrum.spectrumBuffer[i] - (darkCurrent.spectrumBuffer[i] + drift)
            }
            
            // set darkCorrected flag in headers
            spectrum.spectrumHeader.vinirHeader.darkSubtracted = DarkSubtracted.Yes
            spectrum.spectrumHeader.swir1Header.darkSubtracted = DarkSubtracted.Yes
            spectrum.spectrumHeader.swir2Header.darkSubtracted = DarkSubtracted.Yes
            
            print("DarkCurrent corrected")
            
        }
        
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
