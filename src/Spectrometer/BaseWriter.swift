//
//  BaseWriter.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 13.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class BaseWriter{
    internal let fileHandle: FileHandle
    
    
    func toByteArray<T>(_ value: T) -> [UInt8] {
        var value = value
        return withUnsafePointer(to: &value) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<T>.size) {
                Array(UnsafeBufferPointer(start: $0, count: MemoryLayout<T>.size))
            }
        }
    }
    
    init(path : String){
        
        let fileManager = FileManager.default
        //  check if the folder already exists
        if fileManager.fileExists( atPath: path ) == true
        {
            do {
                try fileManager.removeItem(atPath: path)
            }
            catch let error as NSError {
                print("Error: \(error)")
            }
        }
        
        fileManager.createFile(atPath: path, contents: nil)

        fileHandle = FileHandle(forWritingAtPath: path)!
        
    }
    
    func writeByte(number:UInt8){
        var mutableNumber = number
        let data = Data(buffer: UnsafeBufferPointer(start: &mutableNumber, count: 1))
        fileHandle.write(data)
    }
    
    func writeInt(number : UInt16){
        var mutableNumber = number
        let data = Data(buffer: UnsafeBufferPointer(start: &mutableNumber, count: 1))
        fileHandle.write(data)
    }
    
    func writeInt(number : Int16){
        var mutableNumber = number
        let data = Data(buffer: UnsafeBufferPointer(start: &mutableNumber, count: 1))
        fileHandle.write(data)
    }
    
    func writeLong(number:UInt32){
        var mutableNumber = number
        let data = Data(buffer: UnsafeBufferPointer(start: &mutableNumber, count: 1))
        fileHandle.write(data)
    }
    
    func writeLong(number:Int32){
        var mutableNumber = number
        let data = Data(buffer: UnsafeBufferPointer(start: &mutableNumber, count: 1))
        fileHandle.write(data)
    }
    
    func writeDouble(number: Double){
        var mutableNumber = number
        let data = Data(buffer: UnsafeBufferPointer(start: &mutableNumber, count: 1))
        fileHandle.write(data)
    }
    
    func writeString(text:String){
        let data = text.data(using: String.Encoding.utf8)
        fileHandle.write(data!)
    }
    
    func writeFloat(number : Float){
        var bytes = toByteArray(number)
        for i in 0...bytes.count-1
        {
            let data = Data(buffer: UnsafeBufferPointer(start: &bytes[i], count: 1))
            fileHandle.write(data)
        }
    }
    
    func writeVersion(number:Int, decimalNumber : Int){
        let upperNibbleProgramVersion = UInt8(number) << 4
        let lowerNibbleProgramVersion = UInt8(decimalNumber)
        var programVersion =  upperNibbleProgramVersion | lowerNibbleProgramVersion
        print(programVersion)
        let data = Data(buffer: UnsafeBufferPointer(start: &programVersion, count: 1))
        fileHandle.write(data)
    }
}
