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
            
            // Redeclaration for easier access in the calculation
            let vinirDarkCurrentCorrection: Float = Float(InstrumentSettingsCache.sharedInstance.vinirDarkCurrentCorrection)
            let currentDrift: Float = Float(spectrum.spectrumHeader.vinirHeader.drift)
            let darkDrift: Float = Float(darkCurrent.spectrumHeader.vinirHeader.drift)
            let drift: Float = vinirDarkCurrentCorrection + (currentDrift - darkDrift)
            let vinirEndingWaveLength = InstrumentSettingsCache.sharedInstance.vinirEndingWavelength
            let vinirStartingWaveLength = InstrumentSettingsCache.sharedInstance.startingWaveLength
            let darkCorrectionRange = vinirEndingWaveLength + 1 - vinirStartingWaveLength
            
            for i in 0...darkCorrectionRange{
                spectrum.spectrumBuffer[i] -= darkCurrent.spectrumBuffer[i] + drift
            }
            
            // set darkCorrected flag in headers
            spectrum.spectrumHeader.vinirHeader.darkSubtracted = DarkSubtracted.Yes
            spectrum.spectrumHeader.swir1Header.darkSubtracted = DarkSubtracted.Yes
            spectrum.spectrumHeader.swir2Header.darkSubtracted = DarkSubtracted.Yes
        }
        return spectrum
    }
    
    class func calculateReflectance(currentSpectrum : FullRangeInterpolatedSpectrum, whiteReferenceSpectrum : FullRangeInterpolatedSpectrum) -> FullRangeInterpolatedSpectrum
    {
        for i in 0...whiteReferenceSpectrum.spectrumBuffer.count-1 {
            currentSpectrum.spectrumBuffer[i] = currentSpectrum.spectrumBuffer[i] / whiteReferenceSpectrum.spectrumBuffer[i]
        }
        
        return currentSpectrum
    }
    
    class func calculateRadiance(){
        
    }
    
}
