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
    
    class func calculateDarkCurrentCorrection(spectrum : FullRangeInterpolatedSpectrum, darkCurrent: FullRangeInterpolatedSpectrum, drift : Float, darkCorrectionRange : Int){
        for i in 0...darkCorrectionRange {
            spectrum.spectrumBuffer[i] -= darkCurrent.spectrumBuffer[i] + drift
        }
        
        // set darkCorrected flag in headers
        spectrum.spectrumHeader.vinirHeader.darkSubtracted = DarkSubtracted.Yes
        spectrum.spectrumHeader.swir1Header.darkSubtracted = DarkSubtracted.Yes
        spectrum.spectrumHeader.swir2Header.darkSubtracted = DarkSubtracted.Yes
    }
    
    class func calculateRadiance(spectrumBuffer: [Float], vinirEnd: Int, swir1Start: Int, swir1End: Int, swir2Start: Int, swir2End: Int, vinirIntegrationTime:Float, swir1Gain:Float, swir2Gain:Float, baseSpectrum : [Double], lampSpectrum : [Double], foreOpticSpectrum : [Double], foIntegrationTime : Double, foSwir1Gain : Double, foSwir2Gain : Double) -> [Float]
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
        for i in 0...vinirEnd{
            resultBuffer[i] = preCalculatedBufferTemp[i] * spectrumBuffer[i] / vinirIntegrationTime
        }
        
        for i in swir1Start...swir1End{
            resultBuffer[i] = preCalculatedBufferTemp[i] * spectrumBuffer[i] / swir1Gain
        }
        
        for i in swir2Start...swir2End{
            resultBuffer[i] = preCalculatedBufferTemp[i] * spectrumBuffer[i] / swir2Gain
        }
        
        return resultBuffer
    }
    
    class func calculateReflectance(currentSpectrum : FullRangeInterpolatedSpectrum, whiteReferenceSpectrum : FullRangeInterpolatedSpectrum) -> FullRangeInterpolatedSpectrum
    {
        currentSpectrum.spectrumBuffer = calculateReflectance(spectrumBuffer: currentSpectrum.spectrumBuffer, whiteReferenceBuffer: whiteReferenceSpectrum.spectrumBuffer)
        
        return currentSpectrum
    }
    
    class func calculateReflectance<T : FloatingPoint>(spectrumBuffer: [T], whiteReferenceBuffer: [T]) -> [T]{
        var resultBuffer = spectrumBuffer
        for i in 0..<whiteReferenceBuffer.count {
            resultBuffer[i] = spectrumBuffer[i] / whiteReferenceBuffer[i]
        }
        return resultBuffer
    }
    
    
     class func calculateReflectanceFromFile(spectrumFile : IndicoFile7) -> [Double]{
        return calculateReflectance(spectrumBuffer: spectrumFile.spectrum, whiteReferenceBuffer: spectrumFile.reference)
    }
    
        
}
