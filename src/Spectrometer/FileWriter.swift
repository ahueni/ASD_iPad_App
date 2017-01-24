//
//  FileWriter.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 11.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class FileWriter : BaseWriter {
    
    func write(spectrum : FullRangeInterpolatedSpectrum, whiteRefrenceSpectrum : FullRangeInterpolatedSpectrum) -> FileHandle{
        
        // ------ Start Header ------
        
        //FileVersion
        writeString(text: "as6")
        
        //comments
        for _ in 1...157{
            writeByte(number: UInt8(0))
        }
        
        //date
        let data = "123456789012345678".data(using: String.Encoding.utf8)
        fileHandle.write(data!)
        
        //ProgramVersion
        writeVersion(number: 6,decimalNumber: 0)
        
        //FileVersion
        writeVersion(number: 8,decimalNumber: 0)
        
        //itTime
        writeByte(number: 0)
        
        //dcCorr
        writeByte(number: 1)
        
        //dcTime
        writeLong(number: UInt32(Date().timeIntervalSince1970))
        
        //dataType
        writeByte(number: 7)
        
        //refTime
        writeLong(number: UInt32(Date().timeIntervalSince1970))
        
        //waveLength
        writeFloat(number: Float(350))
        
        //waveLengthStep
        writeFloat(number: Float(1))
        
        //dataFormat
        writeByte(number: 0)
        
        //oldDcCount
        writeByte(number: 2)
        
        //oldWrCount
        writeByte(number: 4)
        
        //oldSampleCount
        writeByte(number: 10)
        
        //application
        writeByte(number: 10)
        
        //channels
        writeInt(number: UInt16(spectrum.spectrumBuffer.count))
        
        //appData
        for _ in 1...128{
            writeByte(number: UInt8(0))
        }
        
        //gpsData
        for _ in 1...56{
            writeByte(number: UInt8(0))
        }
        
        //integrationTime
        writeLong(number: UInt32(10))
        
        //fo
        writeInt(number: Int16(10))
        
        //dcc current dark collection value
        writeInt(number: Int16(10))
        
        //calibration - calibration series
        writeInt(number: UInt16(10))
        
        //instrument #
        writeInt(number: UInt16(10))
        
        //ymin
        writeLong(number: UInt32(100))
        //ymax
        writeLong(number: UInt32(100))
        //xmin
        writeLong(number: UInt32(100))
        //xmax
        writeLong(number: UInt32(100))
        
        //ip_numbits
        writeInt(number: UInt16(10))
        
        //xmode
        writeByte(number: 8)
        
        //flags
        writeLong(number: UInt32(1))
        
        //dc_count
        writeInt(number: UInt16(2))
        
        //ref_count
        writeInt(number: UInt16(2))
        
        //sample_count
        writeInt(number: UInt16(2))
        
        //instrument
        writeByte(number: 0)
        
        //bulb
        writeLong(number: UInt32(0))
        
        //swir1_gain
        writeInt(number: UInt16(2048))
        
        //swir2_gain
        writeInt(number: UInt16(2048))
        
        //swir1_offset
        writeInt(number: UInt16(2048))
        
        //swir2_offset
        writeInt(number: UInt16(2048))
        
        //splice1_wavelength
        writeFloat(number: 10)
        
        //splice2_wavelength
        writeFloat(number: 10)
        
        //SmartDetectorType
        for _ in 1...27{
            writeByte(number: UInt8(0))
        }
        
        //spare[5]
        for _ in 1...5{
            writeByte(number: UInt8(0))
        }
        
        // ------ End Header ------
        
        //Spectrum Data
        for i in 0...spectrum.spectrumBuffer.count-1 //channels
        {
            writeFloat(number: spectrum.spectrumBuffer[i])
        }
        
        // ------ Start Refrence ------
        
        // ReferenceFlag Write bool with 2 Bytes
        writeByte(number: 1)
        writeByte(number: 1)
        
        //ReferenceTime
        for _ in 1...8{
            writeByte(number: UInt8(0))
        }
        
        //SpectrumTime
        for _ in 1...8{
            writeByte(number: UInt8(0))
        }
        
        //SpectrumDescripton
        writeString(text: "description of spectrum")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        //Refrence Spectrum Data
        
        for i in 0...spectrum.spectrumBuffer.count-1 //channels
        {
            writeFloat(number: whiteRefrenceSpectrum.spectrumBuffer[i])
        }
        
        // ------ End Refrence ------
        
        fileHandle.closeFile()
        print("File updated!")
        
        return fileHandle
    }
}
