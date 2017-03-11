//
//  SpectrometerTests.swift
//  SpectrometerTests
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import XCTest

@testable import Spectrometer

class SpectrometerIOTests: XCTestCase {
    
    var bundle: Bundle!
    
    let tempPath = NSTemporaryDirectory()
    var measurementSettings: MeasurmentSettings!
    
    override func setUp() {
        super.setUp()
        bundle = Bundle(for: type(of: self))
        measurementSettings = MeasurmentSettings(fileName: "modus.asd", comment: "modus test file", path: URL(fileURLWithPath: "notrelevant"), measurmentMode: MeasurementMode.Raw)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParseSpectralData() {
        
        // parse full range interpolated spectrum
        let data = getDataFromResourceFile(name: "spectrum.data")
        let spectrum = parseSpectralData(data: data)
        
        // test the most important properties at spectrum
        XCTAssert(spectrum.spectrumHeader.instrumentHours == 39, "instrument houers failed")
        XCTAssert(spectrum.spectrumHeader.error == .NoError, "instrument error failed")
        
    }
    
    func testReadCalibrationFile() {
        // read calibration file
        let calibrationFilePath = getResourceFilePath(name: "calibration.raw")
        let calibrationFile = readIniFile(filePath: calibrationFilePath)
        
        // test properties of calibration file
        XCTAssertEqual(calibrationFile.instrumentNumber, 16006, "instrument number")
        XCTAssertEqual(calibrationFile.spectrum.count, 2151, "spectral data count is not equal")
    }
    
    func testReadIndico7RawFile() {
        // read raw asd file
        let rawFilePath = getResourceFilePath(name: "raw.asd")
        let rawFile = readIndicoFile(filePath: rawFilePath)
        
        // check all important properties of raw asd file
        XCTAssertEqual(rawFile.spectrum.count, 2151, "buffer length")
        XCTAssertEqual(rawFile.ReferenceFlag, false, "should not be a reference file")
    }
    
    func testReadIndico7ReflectanceFile() {
        // read reflectance asd file
        let refFilePath = getResourceFilePath(name: "ref.asd")
        let refFile = readIndicoFile(filePath: refFilePath)
        
        // check all important properties of reflectance file
        XCTAssertEqual(refFile.spectrum.count, 2151, "buffer length")
        XCTAssertEqual(refFile.ReferenceFlag, true, "should be a reference file")
    }
    
    func testReadIndico7RadianceFile() {
        // read radiance asd file
        let radFilePath = getResourceFilePath(name: "rad.asd")
        let radFile = readIndicoFile(filePath: radFilePath)
        
        // check all important properites of radiance asd file
        XCTAssertEqual(radFile.spectrum.count, 2151, "buffer length")
        XCTAssertEqual(radFile.ReferenceFlag, false, "should not be a reference file")
        XCTAssertEqual(radFile.calibrationCount, 3, "should be a radiacne file with calibration buffers")
        XCTAssertEqual(radFile.calibrationBuffer.count, 3, "should have calibration buffer array")
    }
    
    func testWriteRawData() {
        // temp output path for testing file
        let outputFilePath = URL(fileURLWithPath: tempPath).appendingPathComponent("rawAsdFile.asd")
        
        // load spectrum to write
        let data = getDataFromResourceFile(name: "spectrum.data")
        let spectrum = parseSpectralData(data: data)
        
        // write raw asd file
        measurementSettings.comment = "raw test file"
        measurementSettings.measurmentMode = .Raw
        let indocoWriter = IndicoWriter(path: outputFilePath.path, settings: measurementSettings)
        indocoWriter.writeRaw(spectrum: spectrum)
        
        // read writed file again and validate properties
        let rawFile = readIndicoFile(filePath: outputFilePath.path)
        
        // check all important properties of writed raw file
        XCTAssertEqual(rawFile.spectrum.count, spectrum.spectrumBuffer.count, "buffer length")
        XCTAssertEqual(rawFile.ReferenceFlag, false, "should not be a reference file")
        XCTAssertEqual(rawFile.spectrum, spectrum.spectrumBuffer.getDoubles(), "buffer values")
        
    }
    
    func testWriteReflectanceData() {
        // temp output path for testing file
        let outputFilePath = URL(fileURLWithPath: tempPath).appendingPathComponent("refAsdFile.asd")
        
        // load spectrum to write
        let data = getDataFromResourceFile(name: "spectrum.data")
        let spectrum = parseSpectralData(data: data)
        
        // load whitereference to write
        let dataWR = getDataFromResourceFile(name: "whiteReference.data")
        let whiteReference = parseSpectralData(data: dataWR)
        
        // write reflectance asd file
        measurementSettings.comment = "ref test file"
        measurementSettings.measurmentMode = .Reflectance
        let indocoWriter = IndicoWriter(path: outputFilePath.path, settings: measurementSettings)
        indocoWriter.writeReflectance(spectrum: spectrum, whiteRefrenceSpectrum: whiteReference)
        
        // read and test indico reflectance file
        let refFile = readIndicoFile(filePath: outputFilePath.path)
        
        // check all important properties of reflectance file
        XCTAssertEqual(refFile.ReferenceFlag, true, "should be a reference file")
        XCTAssertEqual(refFile.spectrum.count, spectrum.spectrumBuffer.count, "spectrum buffer length")
        XCTAssertEqual(refFile.spectrum, spectrum.spectrumBuffer.getDoubles(), "spectrum buffer values")
        XCTAssertEqual(refFile.reference.count, whiteReference.spectrumBuffer.count, "spectrum buffer length")
        XCTAssertEqual(refFile.reference, whiteReference.spectrumBuffer.getDoubles(), "refernece buffer values")
    }
    
    func testWriteRadianceData() {
        let baseFile = CalibrationFile()
        let lampFile = CalibrationFile()
        let fiberOpticFile = CalibrationFile()
        let radianceCalibrationFiles = RadianceCalibrationFiles(baseFile: baseFile, lampFile: lampFile, fiberOptic: fiberOpticFile)
        
        // temp output path for testing file
        let outputFilePath = URL(fileURLWithPath: tempPath).appendingPathComponent("radAsdFile.asd")
        
        // load spectrum to write
        let data = getDataFromResourceFile(name: "spectrum.data")
        let spectrum = parseSpectralData(data: data)
        
        // write reflectance asd file
        measurementSettings.comment = "rad test file"
        measurementSettings.measurmentMode = .Radiance
        let indocoWriter = IndicoWriter(path: outputFilePath.path, settings: measurementSettings)
        indocoWriter.writeRadiance(spectrum: spectrum, radianceCalibrationFiles: radianceCalibrationFiles)
        
        // read and test indico radiance file
        let radFile = readIndicoFile(filePath: outputFilePath.path)
        
        // check all important properites of radiance asd file
        XCTAssertEqual(radFile.spectrum.count, spectrum.spectrumBuffer.count, "buffer length")
        XCTAssertEqual(radFile.ReferenceFlag, false, "should not be a reference file")
        XCTAssertEqual(radFile.calibrationCount, 3, "should be a radiacne file with calibration buffers")
        XCTAssertEqual(radFile.calibrationBuffer.count, 3, "should have calibration buffer array")
    }
    
    private func parseSpectralData(data: [UInt8]) -> FullRangeInterpolatedSpectrum {
        // parse spectral data like spectrometer will return to have a full range interpolated spectrum in tests
        let spectrumFileParser = FullRangeInterpolatedSpectrumParser(data: data)
        do {
            return try spectrumFileParser.parse()
        } catch {
            fatalError("parsing error at FullRangeInterpolatedSpectrum")
        }
    }

    private func readIniFile(filePath: String) -> IndicoFileBase {
        // read ini file
        let writedFileBytes = [UInt8](FileManager().contents(atPath: filePath)!)
        
        do {
            return try IndicoIniFileReader(data: writedFileBytes).parse()
        } catch {
            fatalError("could not read ini file")
        }
    }
    
    private func readIndicoFile(filePath: String) -> IndicoFile7 {
        let writedFileBytes = [UInt8](FileManager().contents(atPath: filePath)!)
        do {
            return try IndicoAsdFileReader(data: writedFileBytes).parse()
        } catch {
            fatalError("could not read indico file")
        }
    }
    
    private func getResourceFilePath(name: String) -> String {
        let fileNameComponents = name.components(separatedBy: ".")
        if (fileNameComponents.count != 2) {
            fatalError("wrong file name format")
        }
        if let path = bundle.path(forResource: fileNameComponents.first, ofType: fileNameComponents.last) {
            return path
        }
        fatalError("could not load path of resource file")
    }
    
    private func getDataFromResourceFile(name: String) -> [UInt8] {
        let data = FileManager.default.contents(atPath: getResourceFilePath(name: name))
        if let data = data {
            return [UInt8](data)
        }
        fatalError("could not load data from file")
    }
    
    
}
