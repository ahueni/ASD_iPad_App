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
    
    static let sharedInstance = SpectrumCalculator()
    
    private static var preCalculatedBuffer: [Float] = []
    
    private init() {
    }
    
    public func updateForeopticFiles(base: CalibrationFile, lamp: CalibrationFile, foreoptic: CalibrationFile) {
        
        let vinirEnd: Int = InstrumentSettingsCache.sharedInstance.vinirEndingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        let swir1Start: Int = InstrumentSettingsCache.sharedInstance.s1StartingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        let swir1End: Int = InstrumentSettingsCache.sharedInstance.s1EndingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        let swir2Start: Int = InstrumentSettingsCache.sharedInstance.s2StartingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        let swir2End: Int = InstrumentSettingsCache.sharedInstance.s2EndingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        
        let start = NSDate()
        var lampPiBaseBuffer: [Double] = []
        // calculate lamp and abse spectrum with pi as first step
        for i in 0...swir2End {
            lampPiBaseBuffer.append(lamp.spectrum![i] / Double.pi * base.spectrum![i])
        }
        print("Buffer time: "+start.timeIntervalSinceNow.description)
        
        let calibrationIntegrationTime: Double = Double(foreoptic.integrationTime)
        let foreopticSwir1Gain: Double = Double(2048) / Double(foreoptic.swir1Gain)
        let foreopticSwir2Gain: Double = Double(2048) / Double(foreoptic.swir2Gain)
        
        
        for i in 0...vinirEnd{
            let preCalculatedValue: Double = lampPiBaseBuffer[i] / (foreoptic.spectrum![i] / calibrationIntegrationTime)
            SpectrumCalculator.preCalculatedBuffer.append(Float(preCalculatedValue))
        }
        print("Vinir time: "+start.timeIntervalSinceNow.description)
        
        for i in swir1Start...swir1End{
            let preCalculatedValue:Double = lampPiBaseBuffer[i] / (foreoptic.spectrum![i] / foreopticSwir1Gain)
            SpectrumCalculator.preCalculatedBuffer.append(Float(preCalculatedValue))
        }
        print("Swir1 time: "+start.timeIntervalSinceNow.description)
        
        for i in swir2Start...swir2End{
            let preCalculatedValue:Double = lampPiBaseBuffer[i] / (foreoptic.spectrum![i] / foreopticSwir2Gain)
            SpectrumCalculator.preCalculatedBuffer.append(Float(preCalculatedValue))
        }
        print("Swir2 time: "+start.timeIntervalSinceNow.description)
        
        
    }
    
    class func calculateDarkCurrentCorrection(spectrum : FullRangeInterpolatedSpectrum) -> FullRangeInterpolatedSpectrum
    {
        
        // if dc exists -> do darkcorrection
        if let darkCurrent = InstrumentSettingsCache.sharedInstance.darkCurrent {
            
            // Redeclaration for easier access in the calculation
            let vinirDarkCurrentCorrection: Float = Float(InstrumentSettingsCache.sharedInstance.vinirDarkCurrentCorrection)
            let currentDrift: Float = Float(spectrum.spectrumHeader.vinirHeader.drift)
            let darkDrift: Float = Float(darkCurrent.spectrumHeader.vinirHeader.drift)
            let drift: Float = vinirDarkCurrentCorrection + (currentDrift - darkDrift)
            
            let vinirEndingWaveLength = InstrumentSettingsCache.sharedInstance.vinirEndingWavelength!
            let vinirStartingWaveLength = InstrumentSettingsCache.sharedInstance.startingWaveLength!
            
            let darkCorrectionRange = vinirEndingWaveLength - vinirStartingWaveLength
            
            for i in 0...darkCorrectionRange {
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
    
    class func calculateRadiance(spectrum: FullRangeInterpolatedSpectrum) -> FullRangeInterpolatedSpectrum {
        
        let vinirEnd: Int = InstrumentSettingsCache.sharedInstance.vinirEndingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        let swir1Start: Int = InstrumentSettingsCache.sharedInstance.s1StartingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        let swir1End: Int = InstrumentSettingsCache.sharedInstance.s1EndingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        let swir2Start: Int = InstrumentSettingsCache.sharedInstance.s2StartingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        let swir2End: Int = InstrumentSettingsCache.sharedInstance.s2EndingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        
        let vinirIntegrationTime:Float = IntegrationTimeMapper.mapIndex(index: spectrum.spectrumHeader.vinirHeader.integrationTime).1
        let swir1Gain:Float = Float(2048) / Float(spectrum.spectrumHeader.swir1Header.gain)
        let swir2Gain:Float = Float(2048) / Float(spectrum.spectrumHeader.swir2Header.gain)
        
        let start = NSDate()
        for i in 0...vinirEnd{
            spectrum.spectrumBuffer[i] = preCalculatedBuffer[i] * spectrum.spectrumBuffer[i] / vinirIntegrationTime
        }
        //print("Vinir time: "+start.timeIntervalSinceNow.description)
        
        for i in swir1Start...swir1End{
            spectrum.spectrumBuffer[i] = preCalculatedBuffer[i] * spectrum.spectrumBuffer[i] / swir1Gain
        }
        //print("Swir1 time: "+start.timeIntervalSinceNow.description)
        
        for i in swir2Start...swir2End{
            spectrum.spectrumBuffer[i] = preCalculatedBuffer[i] * spectrum.spectrumBuffer[i] / swir2Gain
        }
        //print("Swir2 time: "+start.timeIntervalSinceNow.description)
        
        
        return spectrum
        
    }
    
}
