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
    
    // this buffer is only used for calculations in real time! (from device)
    // do not use this buffer to calculate file values! (from file)
    private static var preCalculatedBuffer: [Float] = []
    
    private init() {
    }
    
    public class func updateForeopticFiles(base: CalibrationFile, lamp: CalibrationFile, foreoptic: CalibrationFile) {
        let vinirEnd: Int = InstrumentSettingsCache.sharedInstance.vinirEndingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        let swir1Start: Int = InstrumentSettingsCache.sharedInstance.s1StartingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        let swir1End: Int = InstrumentSettingsCache.sharedInstance.s1EndingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        let swir2Start: Int = InstrumentSettingsCache.sharedInstance.s2StartingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        let swir2End: Int = InstrumentSettingsCache.sharedInstance.s2EndingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        
        SpectrumCalculator.preCalculatedBuffer = calculateForeOpticPreCacluclatedValues(vinirEnd: vinirEnd, swir1Start: swir1Start, swir1End: swir1End, swir2Start: swir2Start, swir2End: swir2End, baseSpectrum: base.spectrum!, lampSpectrum: lamp.spectrum!, foreOpticSpectrum : foreoptic.spectrum!, foIntegrationTime : Double(foreoptic.integrationTime), foSwir1Gain : Double(foreoptic.swir1Gain), foSwir2Gain : Double(foreoptic.swir2Gain))
    }
    
    private class func calculateForeOpticPreCacluclatedValues(vinirEnd: Int, swir1Start: Int, swir1End: Int, swir2Start: Int, swir2End: Int, baseSpectrum : [Double], lampSpectrum : [Double], foreOpticSpectrum : [Double], foIntegrationTime : Double, foSwir1Gain : Double, foSwir2Gain : Double) -> [Float]
    {
        var preCalculatedBufferTemp: [Float] = []
        
        let start = NSDate()
        var lampPiBaseBuffer: [Double] = []
        // calculate lamp and abse spectrum with pi as first step
        for i in 0...swir2End {
            lampPiBaseBuffer.append(lampSpectrum[i] / Double.pi * baseSpectrum[i])
        }
        print("Buffer time: "+start.timeIntervalSinceNow.description)
        
        let calibrationIntegrationTime: Double = foIntegrationTime
        let foreopticSwir1Gain: Double = Double(2048) / foSwir1Gain
        let foreopticSwir2Gain: Double = Double(2048) / foSwir2Gain
        
        for i in 0...vinirEnd{
            let preCalculatedValue: Double = lampPiBaseBuffer[i] / (foreOpticSpectrum[i] / calibrationIntegrationTime)
            preCalculatedBufferTemp.append(Float(preCalculatedValue))
        }
        print("Vinir time: "+start.timeIntervalSinceNow.description)
        
        for i in swir1Start...swir1End{
            let preCalculatedValue:Double = lampPiBaseBuffer[i] / (foreOpticSpectrum[i] / foreopticSwir1Gain)
            preCalculatedBufferTemp.append(Float(preCalculatedValue))
        }
        print("Swir1 time: "+start.timeIntervalSinceNow.description)
        
        for i in swir2Start...swir2End{
            let preCalculatedValue:Double = lampPiBaseBuffer[i] / (foreOpticSpectrum[i] / foreopticSwir2Gain)
            preCalculatedBufferTemp.append(Float(preCalculatedValue))
        }
        print("Swir2 time: "+start.timeIntervalSinceNow.description)
        
        return preCalculatedBufferTemp
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
        currentSpectrum.spectrumBuffer = calculateReflectance(spectrumBuffer: currentSpectrum.spectrumBuffer, whiteReferenceBuffer: whiteReferenceSpectrum.spectrumBuffer)
        
        return currentSpectrum
    }
    
    internal static func calculateReflectance<T : FloatingPoint>(spectrumBuffer: [T], whiteReferenceBuffer: [T]) -> [T]{
        var resultBuffer = spectrumBuffer
        for i in 0..<whiteReferenceBuffer.count {
            resultBuffer[i] = spectrumBuffer[i] / whiteReferenceBuffer[i]
        }
        return resultBuffer
    }
    
    class func calculateRadiance(spectrum: FullRangeInterpolatedSpectrum) -> [Float] {
        
        let vinirEnd: Int = InstrumentSettingsCache.sharedInstance.vinirEndingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        let swir1Start: Int = InstrumentSettingsCache.sharedInstance.s1StartingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        let swir1End: Int = InstrumentSettingsCache.sharedInstance.s1EndingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        let swir2Start: Int = InstrumentSettingsCache.sharedInstance.s2StartingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        let swir2End: Int = InstrumentSettingsCache.sharedInstance.s2EndingWavelength - InstrumentSettingsCache.sharedInstance.startingWaveLength
        
        let vinirIntegrationTime:Float = IntegrationTimeMapper.mapIndex(index: spectrum.spectrumHeader.vinirHeader.integrationTime).1
        let swir1Gain:Float = Float(2048) / Float(spectrum.spectrumHeader.swir1Header.gain)
        let swir2Gain:Float = Float(2048) / Float(spectrum.spectrumHeader.swir2Header.gain)
        
        let resultBuffer = calculateRadiance(spectrumBuffer: spectrum.spectrumBuffer, preCalculatedBufferTemp : preCalculatedBuffer, vinirEnd: vinirEnd, swir1Start: swir1Start, swir1End: swir1End, swir2Start: swir2Start, swir2End: swir2End, vinirIntegrationTime:vinirIntegrationTime, swir1Gain:swir1Gain, swir2Gain:swir2Gain)
        
        return resultBuffer
    }
    
    class private func calculateRadiance(spectrumBuffer: [Float], preCalculatedBufferTemp : [Float], vinirEnd: Int, swir1Start: Int, swir1End: Int, swir2Start: Int, swir2End: Int, vinirIntegrationTime:Float, swir1Gain:Float, swir2Gain:Float) -> [Float]{
        var resultBuffer = spectrumBuffer
        //let start = NSDate()
        for i in 0...vinirEnd{
            resultBuffer[i] = preCalculatedBufferTemp[i] * spectrumBuffer[i] / vinirIntegrationTime
        }
        //print("Vinir time: "+start.timeIntervalSinceNow.description)
        
        for i in swir1Start...swir1End{
            resultBuffer[i] = preCalculatedBufferTemp[i] * spectrumBuffer[i] / swir1Gain
        }
        //print("Swir1 time: "+start.timeIntervalSinceNow.description)
        
        for i in swir2Start...swir2End{
            resultBuffer[i] = preCalculatedBufferTemp[i] * spectrumBuffer[i] / swir2Gain
        }
        //print("Swir2 time: "+start.timeIntervalSinceNow.description)
        
        return resultBuffer
    }
    
    class  func calculateReflectanceFromFile(spectrumFile : SpectralFileV8) -> [Double]{
        return calculateReflectance(spectrumBuffer: spectrumFile.spectrum, whiteReferenceBuffer: spectrumFile.reference)
    }
    
    class func calculateRadianceFromFile(spectralFile : SpectralFileV8) -> [Float]{
        let vinirEnd: Int = 650 //Int(spectralFile.channels) - Int(spectralFile.splice2WaveLength) - Int(spectralFile.splice1WaveLength) - 1
        let swir1Start: Int = 651//Int(spectralFile.channels) - Int(spectralFile.splice2WaveLength) - Int(spectralFile.splice1WaveLength)
        let swir1End: Int = 1450//Int(spectralFile.channels) - Int(spectralFile.splice2WaveLength) - 1
        let swir2Start: Int = 1451//Int(spectralFile.channels) - Int(spectralFile.splice2WaveLength)
        let swir2End: Int = 2150//Int(spectralFile.channels)
        
        let foreOptic = spectralFile.calibrationBuffer.filter({$0.calibrationType == CalibrationType.FiberOpticFile}).first!
        
        let foreOpticIntegrationTime = 17//foreOptic.integrationTime
        let swir1Gain = foreOptic.swir1Gain
        let swir2Gain = foreOptic.swir2Gain
        
        let vinirIntegrationTime : Float = 17//Float(spectralFile.integrationTime)
                
        let preCalculatedBufferTemp =  calculateForeOpticPreCacluclatedValues(vinirEnd: vinirEnd, swir1Start: swir1Start, swir1End: swir1End, swir2Start: swir2Start, swir2End: swir2End, baseSpectrum: spectralFile.baseCalibrationData, lampSpectrum: spectralFile.lampCalibrationData, foreOpticSpectrum: spectralFile.fiberOpticData, foIntegrationTime: Double(foreOpticIntegrationTime), foSwir1Gain: Double(swir1Gain), foSwir2Gain: Double(swir2Gain))
        
        var spectrumAsFloatArray = [Float]()
        //convert spectrum to a float array
        for i in spectralFile.spectrum{
            spectrumAsFloatArray.append(Float(i))
        }
        
        let resultSpectrum = calculateRadiance(spectrumBuffer: spectrumAsFloatArray, preCalculatedBufferTemp : preCalculatedBufferTemp, vinirEnd: vinirEnd, swir1Start: swir1Start, swir1End: swir1End, swir2Start: swir2Start, swir2End: swir2End, vinirIntegrationTime:vinirIntegrationTime, swir1Gain:Float(swir1Gain), swir2Gain:Float(swir2Gain))
        
        return resultSpectrum
    }
    
}
