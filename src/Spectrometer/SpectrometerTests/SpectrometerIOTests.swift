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
    
    let tempPath = NSTemporaryDirectory()
    
    var bundle: Bundle!
    var fullRangeInterpolatedSpectrumPath: String!
    var fullRangeInterpolatedSpectrumBytes: [UInt8]!
    
    var fullRangeInterpolatedSpectrum: FullRangeInterpolatedSpectrum?
    
    var measurementSettings: MeasurmentSettings!
    
    override func setUp() {
        super.setUp()
        
        bundle = Bundle(for: type(of: self))
        fullRangeInterpolatedSpectrumPath = getResourceFilePath(name: "spectrum")
        fullRangeInterpolatedSpectrumBytes = [UInt8](FileManager().contents(atPath: fullRangeInterpolatedSpectrumPath)!)
        
        measurementSettings = MeasurmentSettings(fileName: "test01.asd", comment: "testcomment", path: URL(fileURLWithPath: "notrelevant"), measurmentMode: MeasurementMode.Raw)
        
        // parse spectral data like spectrometer will return to have a full range interpolated spectrum in tests
        let spectrumFileParser = FullRangeInterpolatedSpectrumParser(data: fullRangeInterpolatedSpectrumBytes)
        
        do {
            fullRangeInterpolatedSpectrum = try spectrumFileParser.parse()
        } catch {
            fatalError("parsing error at FullRangeInterpolatedSpectrum")
        }
        
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParsedSpectralData() {
        
        // test the most important properties at spectrum
        XCTAssert(fullRangeInterpolatedSpectrum?.spectrumHeader.instrumentHours == 39, "instrument houers failed")
        XCTAssert(fullRangeInterpolatedSpectrum?.spectrumHeader.error == .NoError, "instrument error failed")
        
    }
    
    func testReadCalibrationFile() {
        
        let calibrationFilePath = getResourceFilePath(name: "calibration")
        
        var iniFile: IndicoFileBase? = nil
        do {
            iniFile = try testReadCalibrationFile(filePath: calibrationFilePath)
        } catch {
            XCTFail("error during parsing indico calibration file")
        }
        
        if let iniFile = iniFile {
            XCTAssertEqual(iniFile.comments, "blablubber", "comments are not equal")
        } else {
            XCTFail("no ini file returned")
        }
        
    }
    
    func testReadIndico7RawFile() {
        
    }
    
    func testReadIndico7ReflectanceFile() {
        
    }
    
    func testReadIndico7RadianceFile() {
        
    }
    
    func testWriteRawData() {
        
        // test write raw asd indico file
        let outputFilePath = URL(fileURLWithPath: tempPath).appendingPathComponent("rawAsdFile.asd")
        let indocoWriter = IndicoWriter(path: outputFilePath.path, settings: measurementSettings)
        
        // write raw data file
        indocoWriter.writeRaw(spectrum: fullRangeInterpolatedSpectrum!)
        
        // read and test indico raw file
        do {
            try testReadIndico7RawFile(filePath: outputFilePath.path)
        } catch {
            XCTFail("error during parsing indico raw file")
        }
        
    }
    
    func testWriteReflectanceData() {
        
    }
    
    func testWriteRadianceData() {
        
    }

    
    private func testReadCalibrationFile(filePath: String) throws -> IndicoFileBase {
        // read ini file
        let writedFileBytes = [UInt8](FileManager().contents(atPath: filePath)!)
        return try IndicoIniFileReader(data: writedFileBytes).parse()
    }
    
    private func testReadIndico7RawFile(filePath: String) throws {
        
        let rawFile = try readIndicoFile(filePath: filePath)
        
        // check all important properties of indico raw file
        XCTAssert(rawFile.comments == "testcomment", "comments not correct")
        
        let firstBeforeWrite:Float = (fullRangeInterpolatedSpectrum?.spectrumBuffer.first)!
        let firstAfterWrite:Float = Float(rawFile.spectrum.first!)
        XCTAssertEqual(firstBeforeWrite, firstAfterWrite, "first buffer value not the same")
        
    }
    
    private func testReadIndico7RefFile(filePath: String) {
        
    }
    
    private func testReadIndico7RadFile(filePath: String) {
        
    }
    
    private func readIndicoFile(filePath: String) throws -> IndicoFile7 {
        // read indico file
        let writedFileBytes = [UInt8](FileManager().contents(atPath: filePath)!)
        return try IndicoAsdFileReader(data: writedFileBytes).parse()
    }
    
    private func getResourceFilePath(name: String) -> String {
        return bundle.path(forResource: name, ofType: "test")!
    }
    
    
}
