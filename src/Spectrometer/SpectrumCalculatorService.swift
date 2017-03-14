//
//  SpectrumCalculatorService.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 14.03.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

//This class is a service for easier access the spectrumCalculator class. It will first get all needed parameters and then call the SpectrumCaluculator
class SpectrumCalculatorService{
    
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
            
            SpectrumCalculator.calculateDarkCurrentCorrection(spectrum: spectrum, darkCurrent: darkCurrent, drift: drift, darkCorrectionRange: darkCorrectionRange)
        }
        return spectrum
    }
    
    class func calculateRadiance(spectrum: FullRangeInterpolatedSpectrum) -> [Float] {
        // Redeclaration for easier access in the calculation
        let vinirEnd: Int = InstrumentStore.sharedInstance.vinirEndingWavelength - InstrumentStore.sharedInstance.startingWaveLength
        let swir1Start: Int = InstrumentStore.sharedInstance.s1StartingWavelength - InstrumentStore.sharedInstance.startingWaveLength
        let swir1End: Int = InstrumentStore.sharedInstance.s1EndingWavelength - InstrumentStore.sharedInstance.startingWaveLength
        let swir2Start: Int = InstrumentStore.sharedInstance.s2StartingWavelength - InstrumentStore.sharedInstance.startingWaveLength
        let swir2End: Int = InstrumentStore.sharedInstance.s2EndingWavelength - InstrumentStore.sharedInstance.startingWaveLength
        
        let vinirIntegrationTime:Float =  IntegrationTime.getIntegrationTime(index: spectrum.spectrumHeader.vinirHeader.integrationTime)
        let swir1Gain:Float = Float(2048) / Float(spectrum.spectrumHeader.swir1Header.gain)
        let swir2Gain:Float = Float(2048) / Float(spectrum.spectrumHeader.swir2Header.gain)
        
        let baseSpectrum = ViewStore.sharedInstance.instrumentConfiguration.base!.spectrum
        let lampSpectrum = ViewStore.sharedInstance.instrumentConfiguration.lamp!.spectrum
        let foreOpticSpectrum = InstrumentStore.sharedInstance.selectedForeOptic!.spectrum
        
        let foreOpticIntegrationTime = InstrumentStore.sharedInstance.selectedForeOptic!.integrationTime
        let foreOpticSwir1Gain = InstrumentStore.sharedInstance.selectedForeOptic!.swir1Gain
        let foreOpticSwir2Gain = InstrumentStore.sharedInstance.selectedForeOptic!.swir2Gain
        
        //call core function wich calculates the radiance
        return SpectrumCalculator.calculateRadiance(spectrumBuffer: spectrum.spectrumBuffer, vinirEnd: vinirEnd, swir1Start: swir1Start, swir1End: swir1End, swir2Start: swir2Start, swir2End: swir2End, vinirIntegrationTime:vinirIntegrationTime, swir1Gain:swir1Gain, swir2Gain:swir2Gain, baseSpectrum : baseSpectrum!, lampSpectrum : lampSpectrum!, foreOpticSpectrum : foreOpticSpectrum!, foIntegrationTime : Double(foreOpticIntegrationTime), foSwir1Gain : Double(foreOpticSwir1Gain), foSwir2Gain : Double(foreOpticSwir2Gain))
    }
    
    class func calculateRadianceFromFile(spectralFile : IndicoFile7) -> [Float]{
        // get init variables from file
        let vinirEnd: Int = Int(spectralFile.splice1WaveLength) - Int(spectralFile.startingWaveLength)
        let swir1Start: Int = vinirEnd + 1
        let swir1End: Int = Int(spectralFile.splice2WaveLength) - Int(spectralFile.startingWaveLength)
        let swir2Start : Int = swir1End + 1
        let swir2End: Int = Int(spectralFile.channels) - 1
        // get foreoptic from file
        let foreOptic = spectralFile.calibrationBuffer.filter({$0.calibrationType == CalibrationType.FiberOpticFile}).first!
        
        var spectrumAsFloatArray = [Float]()
        //convert spectrum to a float array
        for i in spectralFile.spectrum{
            spectrumAsFloatArray.append(Float(i))
        }
        
        //call core function wich calculates the radiance
        return SpectrumCalculator.calculateRadiance(spectrumBuffer: spectrumAsFloatArray, vinirEnd: vinirEnd, swir1Start: swir1Start, swir1End: swir1End, swir2Start: swir2Start, swir2End: swir2End, vinirIntegrationTime:Float(spectralFile.integrationTime), swir1Gain:Float(spectralFile.swir1Gain), swir2Gain:Float(spectralFile.swir2Gain), baseSpectrum : spectralFile.baseCalibrationData, lampSpectrum : spectralFile.lampCalibrationData, foreOpticSpectrum : spectralFile.fiberOpticData, foIntegrationTime : Double(foreOptic.integrationTime), foSwir1Gain : Double(foreOptic.swir1Gain), foSwir2Gain : Double(foreOptic.swir2Gain))
    }


    
}
