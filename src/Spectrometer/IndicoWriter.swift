//
//  FileWriter.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 11.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class IndicoWriter : BaseWriter {
    
    func write(spectrum : FullRangeInterpolatedSpectrum, whiteRefrenceSpectrum : FullRangeInterpolatedSpectrum) -> FileHandle{
        
        // ------ Start Header ------
        
        //FileVersion
        writeString(text: "as7")
        
        //comments
        for _ in 1...157{
            writeByte(number: UInt8(0))
        }
        
        //date
        let data = "123456789012345678".data(using: String.Encoding.utf8)
        fileHandle.write(data!)
        
        //ProgramVersion
        //???
        writeVersion(number: 6,decimalNumber: 0)
        
        //FileVersion
        writeVersion(number: 7,decimalNumber: 0)
        
        //itTime - not used after V2.00
        writeByte(number: 0)
        
        //dcCorr
        // in our case always corrected right?
        writeByte(number: 1)
        
        //dcTime
        writeLong(number: UInt32(Date().timeIntervalSince1970))
        
        //dataType
        // which type should we use?
        // DN : 0
        // Reflectance : 1
        // Radiance : 2
        writeByte(number: 0)
        
        //refTime
        writeLong(number: UInt32(Date().timeIntervalSince1970))
        
        //waveLength
        // todo: get from restore command
        writeFloat(number: Float(350))
        
        //waveLengthStep
        // todo: get from restore command
        writeFloat(number: Float(1))
        
        //dataFormat
        writeByte(number: 0)
        
        //oldDcCount
        // ???
        writeByte(number: 2)
        
        //oldWrCount
        // ???
        writeByte(number: 4)
        
        //oldSampleCount
        // ???
        writeByte(number: 10)
        
        //application
        // ???
        writeByte(number: 10)
        
        //channels
        writeInt(number: UInt16(spectrum.spectrumBuffer.count))
        
        //appData
        //APP_DATA - This is a 128 byte field that is used for storing results produced by various real-time processing routines.
        // ???
        for _ in 1...128{
            writeByte(number: UInt8(0))
        }
        
        //gpsData
        for _ in 1...56{
            writeByte(number: UInt8(0))
        }
        
        //integrationTime
        writeLong(number: UInt32(spectrum.spectrumHeader.vinirHeader.integrationTime))
        
        //fo
        // Default :0
        // else view in degrees
        writeInt(number: Int16(10))
        
        //dcc current dark collection value
        // is this the drift which was used? -> 0
        writeInt(number: Int16(0))
        
        //calibration - calibration series
        // Number of the numbered calibration file
        writeInt(number: UInt16(10))
        
        //instrument #
        // Is this the version number of the spectrometer
        // Serial number
        writeInt(number: UInt16(10))
        
        //ymin
        // ???
        writeLong(number: UInt32(100))
        
        //ymax
        // ???
        writeLong(number: UInt32(100))
        
        //xmin
        // ???
        writeLong(number: UInt32(100))
        
        //xmax
        // ???
        writeLong(number: UInt32(100))
        
        //ip_numbits
        // ???
        writeInt(number: UInt16(10))
        
        //xmode
        // ???
        writeByte(number: 8)
        
        //flags
        //vnir saturation =1
        //swir1 satruation = 2
        //swir2 saturation = 3
        //Tec1 alarm= 8
        //Tec2 alarm = 16
        // ???
        writeLong(number: UInt32(1))
        
        //dc_count
        // todo: take from settings
        writeInt(number: UInt16(2))
        
        //ref_count
        // todo: take from settings
        writeInt(number: UInt16(2))
        
        //sample_count
        // todo: take from settings
        writeInt(number: UInt16(2))
        
        //instrument type
        // Zwei unterschiedliche InstrumentType Tabellen in den Spezifikationen????
        writeByte(number: UInt8(0))//spectrum.spectrumHeader.instrumentType))
        
        //bulb
        // ???
        writeLong(number: UInt32(0))
        
        //swir1_gain
        writeInt(number: UInt16(spectrum.spectrumHeader.swir1Header.gain))
        
        //swir2_gain
        writeInt(number: UInt16(spectrum.spectrumHeader.swir2Header.gain))
        
        //swir1_offset
        writeInt(number: UInt16(spectrum.spectrumHeader.swir1Header.offset))
        
        //swir2_offset
        writeInt(number: UInt16(spectrum.spectrumHeader.swir2Header.gain))
        
        //splice1_wavelength
        // beetween which vinir and swir 1
        // ???
        writeFloat(number: 1000)
        
        //splice2_wavelength
        // beetween which swir1 and swir 2
        // ???
        writeFloat(number: 1850)
        
        //SmartDetectorType
        // ???
        for _ in 1...27{
            writeByte(number: UInt8(0))
        }
        
        //spare[5]
        // ???
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
        // which format???
        for _ in 1...8{
            writeByte(number: UInt8(0))
        }
        
        //SpectrumTime
        // which format???
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
        
        
        // ------ Start Classifier Data ------
        
        // yCode
        // Type of Classifier Data - 0=SAM, 1=GALACTIC, 2=CAMOPREDICT, 3=CAMOCLASSIFY, 4=PCAZ, 5=INFOMETRIX
        // ???
        writeByte(number: 0)
        
        // yModelType
        // Type of Model Quantify/Classify or both
        // ???
        writeByte(number: 0)
        
        // stitle
        writeString(text: "Title of Classifier")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        //  sSubTitle
        writeString(text: "Subtitle of Classifier")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        // sProductName
        writeString(text: "ProductName")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        // sVendor
        writeString(text: "Vendor")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        // sLotNumber
        writeString(text: "LotNumber")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        // sSample
        writeString(text: "Sample Description")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        // sModelName
        writeString(text: "Model Description")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        // sOperator
        writeString(text: "Operator Name")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        // sDateTime
        writeString(text: "Date/time sample taken")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        // sInstrument
        writeString(text: "Instrument Name")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        // sSerialNumber
        writeString(text: "Serial Number of Instrument")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        // sDisplayMode
        writeString(text: "Display Mode")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        // sComments
        writeString(text: "Comments for Sample")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        // sUnits
        writeString(text: "Units of Concentration")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        // sFileName
        writeString(text: "File Name for sample")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        // sUserName
        writeString(text: "User Name")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        // sReserved1
        writeString(text: "Reservered")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        // sReserved2
        writeString(text: "Reservered")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        // sReserved3
        writeString(text: "Reservered")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        // sReserved4
        writeString(text: "Reservered")
        writeByte(number: UInt8(0)) // End the Description with zero byte
        
        //iConstituentCount
        // ???
        writeInt(number: Int16(0))
        
        // actConstituent()
        // todo : implement for loop
        
        // ------ End Classifier Data ------
        
        // ------ Start Dependent Variable Data ------
        
        // SaveDependentVariables
        writeByte(number: 1)
        
        
        
        // ------ End Dependent Variable Data ------
        
        // ------ Start Calibration Header ------
        
        
        
        // ------ End Calibration Header ------
        
        
        
        // ------ Start Base Data ------
        
        
        
        // ------ End Base Data ------
        
        
        
        
        // ------ Start Lamp Data ------
        
        
        
        // ------ End Lamp Data ------
        
        
        
        
        // ------ Start Fiber Optic Data ------
        
        
        
        // ------ End Fiber Optic Data ------
        
        fileHandle.closeFile()
        print("File updated!")
        
        return fileHandle
    }
}
