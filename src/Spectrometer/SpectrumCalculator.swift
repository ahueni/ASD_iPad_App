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
    
    private init() {
    }
    
    private class func calculateRadiance(spectrumBuffer: [Float], vinirEnd: Int, swir1Start: Int, swir1End: Int, swir2Start: Int, swir2End: Int, vinirIntegrationTime:Float, swir1Gain:Float, swir2Gain:Float, baseSpectrum : [Double], lampSpectrum : [Double], foreOpticSpectrum : [Double], foIntegrationTime : Double, foSwir1Gain : Double, foSwir2Gain : Double) -> [Float]
    {
        var preCalculatedBufferTemp: [Float] = []
        
        var lampPiBaseBuffer: [Double] = []
        // calculate lamp and abse spectrum with pi as first step
        for i in 0...swir2End {
            lampPiBaseBuffer.append(lampSpectrum[i] / Double.pi * baseSpectrum[i])
        }
        
        let calibrationIntegrationTime: Double = foIntegrationTime
        let foreopticSwir1Gain: Double = Double(2048) / foSwir1Gain
        let foreopticSwir2Gain: Double = Double(2048) / foSwir2Gain
        
        for i in 0...vinirEnd{
            let preCalculatedValue: Double = lampPiBaseBuffer[i] / (foreOpticSpectrum[i] / calibrationIntegrationTime)
            preCalculatedBufferTemp.append(Float(preCalculatedValue))
        }
        
        for i in swir1Start...swir1End{
            let preCalculatedValue:Double = lampPiBaseBuffer[i] / (foreOpticSpectrum[i] / foreopticSwir1Gain)
            preCalculatedBufferTemp.append(Float(preCalculatedValue))
        }
        
        for i in swir2Start...swir2End{
            let preCalculatedValue:Double = lampPiBaseBuffer[i] / (foreOpticSpectrum[i] / foreopticSwir2Gain)
            preCalculatedBufferTemp.append(Float(preCalculatedValue))
        }
        
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
    
    class func calculateDarkCurrentCorrection(spectrum : FullRangeInterpolatedSpectrum) -> FullRangeInterpolatedSpectrum
    {
        // if dc exists -> do darkcorrection
        if let darkCurrent = InstrumentStore.sharedInstance.darkCurrent {
            
            // Redeclaration for easier access in the calculation
            let vinirDarkCurrentCorrection: Float = Float(InstrumentStore.sharedInstance.vinirDarkCurrentCorrection)
            let currentDrift: Float = Float(spectrum.spectrumHeader.vinirHeader.drift)
            let darkDrift: Float = Float(darkCurrent.spectrumHeader.vinirHeader.drift)
            let drift: Float = vinirDarkCurrentCorrection + (currentDrift - darkDrift)
            
            let vinirEndingWaveLength = InstrumentStore.sharedInstance.vinirEndingWavelength!
            let vinirStartingWaveLength = InstrumentStore.sharedInstance.startingWaveLength!
            
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
        
        let vinirEnd: Int = InstrumentStore.sharedInstance.vinirEndingWavelength - InstrumentStore.sharedInstance.startingWaveLength
        let swir1Start: Int = InstrumentStore.sharedInstance.s1StartingWavelength - InstrumentStore.sharedInstance.startingWaveLength
        let swir1End: Int = InstrumentStore.sharedInstance.s1EndingWavelength - InstrumentStore.sharedInstance.startingWaveLength
        let swir2Start: Int = InstrumentStore.sharedInstance.s2StartingWavelength - InstrumentStore.sharedInstance.startingWaveLength
        let swir2End: Int = InstrumentStore.sharedInstance.s2EndingWavelength - InstrumentStore.sharedInstance.startingWaveLength
        
        let vinirIntegrationTime:Float = IntegrationTimeMapper.mapIndex(index: spectrum.spectrumHeader.vinirHeader.integrationTime).1
        let swir1Gain:Float = Float(2048) / Float(spectrum.spectrumHeader.swir1Header.gain)
        let swir2Gain:Float = Float(2048) / Float(spectrum.spectrumHeader.swir2Header.gain)
        
        let baseSpectrum = InstrumentStore.sharedInstance.instrumentConfiguration.base!.spectrum
        let lampSpectrum = InstrumentStore.sharedInstance.instrumentConfiguration.lamp!.spectrum
        let foreOpticSpectrum = InstrumentStore.sharedInstance.selectedForeOptic!.spectrum
        
        let foreOpticIntegrationTime = InstrumentStore.sharedInstance.selectedForeOptic!.integrationTime
        let foreOpticSwir1Gain = InstrumentStore.sharedInstance.selectedForeOptic!.swir1Gain
        let foreOpticSwir2Gain = InstrumentStore.sharedInstance.selectedForeOptic!.swir2Gain
        
        let resultBuffer = calculateRadiance(spectrumBuffer: spectrum.spectrumBuffer, vinirEnd: vinirEnd, swir1Start: swir1Start, swir1End: swir1End, swir2Start: swir2Start, swir2End: swir2End, vinirIntegrationTime:vinirIntegrationTime, swir1Gain:swir1Gain, swir2Gain:swir2Gain, baseSpectrum : baseSpectrum!, lampSpectrum : lampSpectrum!, foreOpticSpectrum : foreOpticSpectrum!, foIntegrationTime : Double(foreOpticIntegrationTime), foSwir1Gain : Double(foreOpticSwir1Gain), foSwir2Gain : Double(foreOpticSwir2Gain))
        
        return resultBuffer
    }
    
    class  func calculateReflectanceFromFile(spectrumFile : IndicoFile7) -> [Double]{
        return calculateReflectance(spectrumBuffer: spectrumFile.spectrum, whiteReferenceBuffer: spectrumFile.reference)
    }
    
    class func calculateRadianceFromFile(spectralFile : IndicoFile7) -> [Float]{
        let vinirEnd: Int = 650 //Int(spectralFile.channels) - Int(spectralFile.splice2WaveLength) - Int(spectralFile.splice1WaveLength) - 1
        let swir1Start: Int = 651//Int(spectralFile.channels) - Int(spectralFile.splice2WaveLength) - Int(spectralFile.splice1WaveLength)
        let swir1End: Int = 1450//Int(spectralFile.channels) - Int(spectralFile.splice2WaveLength) - 1
        let swir2Start: Int = 1451//Int(spectralFile.channels) - Int(spectralFile.splice2WaveLength)
        let swir2End: Int = 2150//Int(spectralFile.channels)
        
        let foreOptic = spectralFile.calibrationBuffer.filter({$0.calibrationType == CalibrationType.FiberOpticFile}).first!
        
        var spectrumAsFloatArray = [Float]()
        //convert spectrum to a float array
        for i in spectralFile.spectrum{
            spectrumAsFloatArray.append(Float(i))
        }
        
        return calculateRadiance(spectrumBuffer: spectrumAsFloatArray, vinirEnd: vinirEnd, swir1Start: swir1Start, swir1End: swir1End, swir2Start: swir2Start, swir2End: swir2End, vinirIntegrationTime:Float(spectralFile.integrationTime), swir1Gain:Float(spectralFile.swir1Gain), swir2Gain:Float(spectralFile.swir2Gain), baseSpectrum : spectralFile.baseCalibrationData, lampSpectrum : spectralFile.lampCalibrationData, foreOpticSpectrum : spectralFile.fiberOpticData, foIntegrationTime : Double(foreOptic.integrationTime), foSwir1Gain : Double(foreOptic.swir1Gain), foSwir2Gain : Double(foreOptic.swir2Gain))
    }
    
}
