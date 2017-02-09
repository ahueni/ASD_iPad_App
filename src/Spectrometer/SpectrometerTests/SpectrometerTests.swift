//
//  SpectrometerTests.swift
//  SpectrometerTests
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import XCTest
@testable import Spectrometer

class SpectrometerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let bundle = Bundle(for: type(of: self))
        let spectrumPath = bundle.path(forResource: "spectrum", ofType: "test")!
        let spectrumDataBuffer = [UInt8](FileManager().contents(atPath: spectrumPath)!)
        
        
        let whiteRefrencePath = bundle.path(forResource: "whiteRefrence", ofType: "test")!
        let whiteRefrenceDataBuffer = [UInt8](FileManager().contents(atPath: whiteRefrencePath)!)
        
        let spectrumFileParser = FullRangeInterpolatedSpectrumParser(data: spectrumDataBuffer)
        let whiteRefrenceFileParser = FullRangeInterpolatedSpectrumParser(data: whiteRefrenceDataBuffer)
        do{
            
            var fullRangeSpectrum = try spectrumFileParser.parse();
            var whiteRefrenceSpectrum = try whiteRefrenceFileParser.parse();
            
            let dirPath = NSTemporaryDirectory()
            let testFileURL = URL(fileURLWithPath: dirPath).appendingPathComponent("write.test")
            let canCreate = FileManager.default.isWritableFile(atPath: dirPath)
            let writer = IndicoWriter(path: testFileURL.relativePath)
            let fileHandle = writer.write(spectrum: fullRangeSpectrum, whiteRefrenceSpectrum: whiteRefrenceSpectrum)
            
            let testFileDataBuffer = [UInt8](FileManager().contents(atPath: testFileURL.relativePath)!)
            let testFileReader = IndicoAsdFileReader(data: testFileDataBuffer)
            let parsedAsdTestFile = try testFileReader.parse()
            
            print("test")
        }
        catch{
            
        }
        
        /*
        let fileUrl = URL(fileURLWithPath: "TestResources/spectrum.test")
        
        let filePath = fileUrl.absoluteString
        let dataBuffer = [UInt8](FileManager().contents(atPath: filePath)!)
        let fileParser = IndicoIniFileReader(data: dataBuffer)
 */
 
        XCTAssert(true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
