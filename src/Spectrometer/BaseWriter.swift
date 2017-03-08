//
//  BaseWriter.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 13.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class BaseWriter{
    internal let fileHandle: FileHandle!
    internal let settings: MeasurmentSettings!
    
    func toByteArray<T>(_ value: T) -> [UInt8] {
        var value = value
        return withUnsafePointer(to: &value) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<T>.size) {
                Array(UnsafeBufferPointer(start: $0, count: MemoryLayout<T>.size))
            }
        }
    }
    
    init(path : String, settings : MeasurmentSettings) {
        
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
        if(!(fileManager.fileExists(atPath: path)))
        {
            print("File not created, use relativepath instead of absolut")
        }
        fileHandle = FileHandle(forWritingAtPath: path)!
        self.settings = settings
    }
    
    enum FileError : Error {
        case fileNotCreatedError(message : String)
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
    
    func writePrefixedString(text: String)
    {
        writeInt(number: UInt16(text.characters.count))
        writeString(text: text)

    }
    
    func writeString(text:String){
        let data = text.data(using: String.Encoding.utf8)
        fileHandle.write(data!)
    }
    
    func writeStringWithFixedLength(text : String, length : Int){
        let data = text.data(using: String.Encoding.utf8)
        fileHandle.write(data!)
        
        let paddingLength = length - text.lengthOfBytes(using: String.Encoding.utf8)
        for _ in 1...paddingLength{
            writeByte(number: 0)
        }
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
