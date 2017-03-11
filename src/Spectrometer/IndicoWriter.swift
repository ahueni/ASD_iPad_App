//
//  FileWriter.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 11.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class RadianceCalibrationFiles{
    var baseFile : CalibrationFile
    var lampFile : CalibrationFile
    var fiberOptic : CalibrationFile
    
    init(baseFile : CalibrationFile, lampFile : CalibrationFile, fiberOptic : CalibrationFile) {
        self.baseFile = baseFile
        self.lampFile = lampFile
        self.fiberOptic = fiberOptic
    }
}

class IndicoWriter : BaseWriter {
    
    func writeRaw(spectrum : FullRangeInterpolatedSpectrum){
        // write all basic file values
        innerWriteBasic(spectrum: spectrum, dataType: DataType.RawType)

        // Calibration Header Count
        writeByte(number: 0)
        fileHandle.closeFile()
    }
    
    func writeReflectance(spectrum : FullRangeInterpolatedSpectrum, whiteRefrenceSpectrum : FullRangeInterpolatedSpectrum?){
        // write all basic file values with WhiteReference
        innerWriteBasic(spectrum: spectrum, dataType: DataType.RefType, whiteRefrenceSpectrum: whiteRefrenceSpectrum)
        
        // Calibration Header Count
        writeByte(number: 0)
        fileHandle.closeFile()
    }
    
    func writeRadiance(spectrum : FullRangeInterpolatedSpectrum, radianceCalibrationFiles : RadianceCalibrationFiles){
        // write all basic file values
        innerWriteBasic(spectrum: spectrum, dataType: DataType.RadType)
        
        // write calibration files
        innerWriteCalibration(radianceCalibrationFiles: radianceCalibrationFiles)
        fileHandle.closeFile()
    }

    
    private func innerWriteBasic(spectrum : FullRangeInterpolatedSpectrum, dataType : DataType, whiteRefrenceSpectrum : FullRangeInterpolatedSpectrum? = nil){
        
        // ------ Start Header ------
        
        //FileVersion
        writeString(text: "as7")
        
        //comments
        //max 157 characters
        writeStringWithFixedLength(text: settings.comment!, length: 157)
        
        //date
        writeActualDateTime()
        
        //ProgramVersion
        //???
        writeVersion(number: 6,decimalNumber: 0)
        
        //FileVersion
        writeVersion(number: 7,decimalNumber: 0)
        
        //itTime - not used after V2.00
        writeByte(number: 0)
        
        //dcCorr
        writeByte(number: UInt8(spectrum.spectrumHeader.vinirHeader.darkSubtracted.rawValue))
        
        //dcTime
        writeLong(number: UInt32(Date().timeIntervalSince1970))
        
        //dataType
        // DN : 0
        // Reflectance : 1
        // Radiance : 2
        writeByte(number: dataType.rawValue)
        
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
        
        //integrationTime -> Decimals will be cut. This is the same behaviour as the rs3 software
        let integrationTime = IntegrationTime.getIntegrationTime(index: spectrum.spectrumHeader.vinirHeader.integrationTime)
        writeLong(number: UInt32(integrationTime))
        
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
        writeFloat(number: 1000)
        
        //splice2_wavelength
        // beetween which swir1 and swir 2
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
        if(whiteRefrenceSpectrum != nil)
        {
            writeByte(number: 1)
            writeByte(number: 1)
        }
        else
        {
            writeByte(number: 0)
            writeByte(number: 0)
        }
        
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
        writePrefixedString(text: "description of spectrum")
        
        //Refrence Spectrum Data
        for i in 0...spectrum.spectrumBuffer.count-1 //channels
        {
            if(whiteRefrenceSpectrum == nil)
            {
                writeFloat(number: 0)
            }
            else
            {
                writeFloat(number: whiteRefrenceSpectrum!.spectrumBuffer[i])
            }
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
        writePrefixedString(text: "Title of Classifier")
        
        //  sSubTitle
        writePrefixedString(text: "Subtitle of Classifier")
        
        // sProductName
        writePrefixedString(text: "ProductName")
        
        // sVendor
        writePrefixedString(text: "Vendor")
        
        // sLotNumber
        writePrefixedString(text: "LotNumber")
        
        // sSample
        writePrefixedString(text: "Sample Description")
        
        // sModelName
        writePrefixedString(text: "Model Description")
        
        // sOperator
        writePrefixedString(text: "Operator Name")
        
        // sDateTime
        writePrefixedString(text: "Date/time sample taken")
        
        // sInstrument
        writePrefixedString(text: "Instrument Name")
        
        // sSerialNumber
        writePrefixedString(text: "Serial Number of Instrument")
        
        // sDisplayMode
        writePrefixedString(text: "Display Mode")
        
        // sComments
        writePrefixedString(text: "Comments for Sample")
        
        // sUnits
        writePrefixedString(text: "Units of Concentration")
        
        // sFileName
        writePrefixedString(text: "File Name for sample")
        
        // sUserName
        writePrefixedString(text: "User Name")
        
        // sReserved1
        writePrefixedString(text: "Reservered")
        
        // sReserved2
        writePrefixedString(text: "Reservered")
        
        // sReserved3
        writePrefixedString(text: "Reservered")
        
        // sReserved4
        writePrefixedString(text: "Reservered")
        
        //iConstituentCount
        // ???
        writeInt(number: Int16(0))
        
        // actConstituent()
        // todo : implement for loop
        
        // ------ End Classifier Data ------
        
        // ------ Start Dependent Variable Data ------
        
        // SaveDependentVariables
        writeByte(number: 1)
        
        // DependentVariableCount
        writeInt(number: UInt16(0))
        
        // Skip
        writeByte(number: 0)
        
        // DependentVariableLabels()
        writePrefixedString(text: "DependentVariableLabels")
        
        // DependentVariables()
        writeFloat(number: 0)
        
        // ------ End Dependent Variable Data ------
    }
    
    
    
    private func innerWriteCalibration(radianceCalibrationFiles : RadianceCalibrationFiles){
        // ------ Start Calibration Header ------
        
        // Count => In this project the calibration count is always 3 if measurment is radiance. 1x Base, 1x Lamp & 1x Foreoptic
        writeByte(number: 3)
        
        //Write Base File header
        writeByte(number: UInt8(radianceCalibrationFiles.baseFile.type))
        writeStringWithFixedLength(text: radianceCalibrationFiles.baseFile.filename!, length: 20)
        writeLong(number: radianceCalibrationFiles.baseFile.integrationTime)
        writeInt(number: radianceCalibrationFiles.baseFile.swir1Gain)
        writeInt(number: radianceCalibrationFiles.baseFile.swir2Gain)
        
        //Write Lamp File header
        writeByte(number: UInt8(radianceCalibrationFiles.lampFile.type))
        writeStringWithFixedLength(text: radianceCalibrationFiles.lampFile.filename!, length: 20)
        writeLong(number: radianceCalibrationFiles.lampFile.integrationTime)
        writeInt(number: radianceCalibrationFiles.lampFile.swir1Gain)
        writeInt(number: radianceCalibrationFiles.lampFile.swir2Gain)
        
        //Write Foreoptic File header
        writeByte(number: UInt8(radianceCalibrationFiles.fiberOptic.type))
        writeStringWithFixedLength(text: radianceCalibrationFiles.fiberOptic.filename!, length: 20)
        writeLong(number: radianceCalibrationFiles.fiberOptic.integrationTime)
        writeInt(number: radianceCalibrationFiles.fiberOptic.swir1Gain)
        writeInt(number: radianceCalibrationFiles.fiberOptic.swir2Gain)
        
        // ------ End Calibration Header ------
        
        // ------ Start Base Data ------
        
        let baseFileBuffer = radianceCalibrationFiles.baseFile.spectrum!
        for i in 0...radianceCalibrationFiles.baseFile.spectrum!.count-1
        {
            writeDouble(number: baseFileBuffer[i])
        }
        
        // ------ End Base Data ------
        
        // ------ Start Lamp Data ------
        
        let lampFileBuffer = radianceCalibrationFiles.lampFile.spectrum!
        for i in 0...radianceCalibrationFiles.lampFile.spectrum!.count-1
        {
            writeDouble(number: lampFileBuffer[i])
        }
        
        // ------ End Lamp Data ------
        
        // ------ Start Fiber Optic Data ------
        
        let fiberOpticBuffer = radianceCalibrationFiles.fiberOptic.spectrum!
        for i in 0...radianceCalibrationFiles.fiberOptic.spectrum!.count-1
        {
            writeDouble(number: fiberOpticBuffer[i])
        }
        
        // ------ End Fiber Optic Data ------
    }
}
