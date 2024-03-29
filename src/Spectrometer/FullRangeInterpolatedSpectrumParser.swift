//
//  FullRangeInterpolatedSpectrumParser.swift
//  Spectrometer
//
//  Created by raphi on 19.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

class FullRangeInterpolatedSpectrumParser: BaseSpectrumInput, ISpectrumParser {
    
    typealias T = FullRangeInterpolatedSpectrum
    
    func parse() throws -> T {
        
        if self.data.count < T.SIZE {
            throw SpectrometerError(message: "Response is too short, could not parse spectrum.", kind: .parsingError)
        }
        
        // first parse spectrum header values
        let header: HeaderValues = HeaderValues(fromRawValue: getNextInt())
        let error: ErrorCodes = ErrorCodes(fromRawValue: getNextInt())
        let sampleCount: Int = getNextInt()
        let trigger: Int = getNextInt()
        let voltage: Float = getNextFloat()
        let current: Int = getNextInt()
        let temperature: Int = getNextInt()
        let motorCurrent: Int = getNextInt()
        let instrumentHours: Int = getNextInt()
        let instrumentMinutes: Int = getNextInt()
        let instrumentType: Int = getNextInt()
        let AB: Int = getNextInt()
        
        // jump over reserved bytes
        parseIndex += SpectrumHeader.reserve*4
        
        // parse VinirHeader
        let integrationTime: Int = getNextInt()
        let scans: Int = getNextInt()
        let maxChannel: Int = getNextInt()
        let minChannel: Int = getNextInt()
        let saturation: Saturation = try Saturation(fromRawValue: getNextInt())
        let shutter: ShutterStatus = try ShutterStatus(fromRawValue: getNextInt())
        let drift: Int = getNextInt()
        let darkSubtracted: DarkSubtracted = try DarkSubtracted(fromRawValue: getNextInt())
        
        // jum over reserved bytes
        parseIndex += VnirHeader.reserve*4
        
        let vinirHeader = VnirHeader(integrationTime: integrationTime, scans: scans, maxChannel: maxChannel, minChannel: minChannel, saturation: saturation, shutter: shutter, drift: drift, darkSubtracted: darkSubtracted)
        
        // parse Swir1 Header
        let s1tecStatus: TecStatus = try TecStatus(fromRawValue: getNextInt())
        let s1tecCurrent: Int = getNextInt()
        let s1maxChannel: Int = getNextInt()
        let s1minChannel: Int = getNextInt()
        let s1saturation: Saturation = try Saturation(fromRawValue: getNextInt())
        let s1AScans: Int = getNextInt()
        let s1BScans: Int = getNextInt()
        let s1darkCurrent: Int = getNextInt()
        let s1gain: Int = getNextInt()
        let s1offset: Int = getNextInt()
        let s1scansize1: Int = getNextInt()
        let s1scansize2: Int = getNextInt()
        let s1darkSubtracted: DarkSubtracted = try DarkSubtracted(fromRawValue: getNextInt())
        
        // jump over reserved bytes
        parseIndex += SwirHeader.reserve*4
        
        let swir1Header: SwirHeader = SwirHeader(tecStatus: s1tecStatus, tecCurrent: s1tecCurrent, maxChannel: s1maxChannel, minChannel: s1minChannel, saturation: s1saturation, AScans: s1AScans, BScans: s1BScans, darkCurrent: s1darkCurrent, gain: s1gain, offset: s1offset, scansize1: s1scansize1, scansize2: s1scansize2, darkSubtracted: s1darkSubtracted)
        
        // parse Swir2 Header
        let s2tecStatus: TecStatus = try TecStatus(fromRawValue: getNextInt())
        let s2tecCurrent: Int = getNextInt()
        let s2maxChannel: Int = getNextInt()
        let s2minChannel: Int = getNextInt()
        let s2saturation: Saturation = try Saturation(fromRawValue: getNextInt())
        let s2AScans: Int = getNextInt()
        let s2BScans: Int = getNextInt()
        let s2darkCurrent: Int = getNextInt()
        let s2gain: Int = getNextInt()
        let s2offset: Int = getNextInt()
        let s2scansize1: Int = getNextInt()
        let s2scansize2: Int = getNextInt()
        let s2darkSubtracted: DarkSubtracted = try DarkSubtracted(fromRawValue: getNextInt())
        
        // jump over reserved bytes
        parseIndex += SwirHeader.reserve*4
        
        let swir2Header: SwirHeader = SwirHeader(tecStatus: s2tecStatus, tecCurrent: s2tecCurrent, maxChannel: s2maxChannel, minChannel: s2minChannel, saturation: s2saturation, AScans: s2AScans, BScans: s2BScans, darkCurrent: s2darkCurrent, gain: s2gain, offset: s2offset, scansize1: s2scansize1, scansize2: s2scansize2, darkSubtracted: s2darkSubtracted)
        
        let spectrumHeader = SpectrumHeader(header: header, error: error, sampleCount: sampleCount, trigger: trigger, voltage: voltage, current: current, temperature: temperature, motorCurrent: motorCurrent, instrumentHours: instrumentHours, instrumentMinutes: instrumentMinutes, instrumentType: instrumentType, AB: AB, vinirHeader: vinirHeader, swir1Header: swir1Header, swir2Header: swir2Header)
        
        // parse spectrum buffer
        var buffer: [Float] = []
        
        for _ in 0...2150 {
            let value = getNextFloatSpec()
            //print(i.description + " / " + value.description)
            buffer.append(Float(value))
        }
        
        return FullRangeInterpolatedSpectrum(spectrumHeader: spectrumHeader, spectrumBuffer: buffer)
    }
    
}
