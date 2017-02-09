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
        let path = bundle.path(forResource: "spectrum", ofType: "test")!
        
        let dataBuffer = [UInt8](FileManager().contents(atPath: path)!)
        
        let fileParser = FullRangeInterpolatedSpectrumParser(data: dataBuffer)
        do{
        var test = try fileParser.parse();
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
