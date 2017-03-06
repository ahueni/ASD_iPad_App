//
//  BackgroundFileWriteManager.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 28.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class FileWriteManager{
    
    var isWorking : Bool = false
    let serialQueue = DispatchQueue(label: "fileWriteQueue")
    
    static let sharedInstance = FileWriteManager()
    private init() { }
    
    func addToQueueRaw(spectrums : [FullRangeInterpolatedSpectrum], settings: MeasurmentSettings)
    {
        serialQueue.sync {
            for spectrum in spectrums
            {
                let relativeFilePath = createNewFilePath(settings: settings)
                let fileWriter = IndicoWriter(path: relativeFilePath)
                fileWriter.writeRaw(spectrum: spectrum)
            }
        }
    }
    
    func addToQueueReflectance(spectrums : [FullRangeInterpolatedSpectrum], whiteRefrenceSpectrum: FullRangeInterpolatedSpectrum, settings: MeasurmentSettings)
    {
        serialQueue.sync {
            for spectrum in spectrums
            {
                let relativeFilePath = createNewFilePath(settings: settings)
                let fileWriter = IndicoWriter(path: relativeFilePath)
                fileWriter.writeReflectance(spectrum: spectrum, whiteRefrenceSpectrum: whiteRefrenceSpectrum)
            }
        }
    }
    
    func addToQueueRadiance(spectrums : [FullRangeInterpolatedSpectrum], radianceCalibrationFiles: RadianceCalibrationFiles? = nil, settings: MeasurmentSettings, fileSuffix :String = "")
    {
        serialQueue.sync {
            for spectrum in spectrums
            {
                let relativeFilePath = createNewFilePath(settings: settings, fileSuffix: fileSuffix)
                let fileWriter = IndicoWriter(path: relativeFilePath)
                fileWriter.writeRadiance(spectrum: spectrum, radianceCalibrationFiles: radianceCalibrationFiles)
            }
        }
    }
    
    func createNewFilePath(settings: MeasurmentSettings, fileSuffix :String = "") -> String{
        let index = getHighestIndex(filePath: settings.path) + 1
        let fileName = String(format: "%05d_", index) + settings.fileName + fileSuffix + ".asd"
        print(fileName + " queued")
        let relativeFilePath = settings.path.appendingPathComponent(fileName).relativePath
        return relativeFilePath
    }
    
    func addFinishWritingCallBack(callBack: ()->Void){
        serialQueue.sync {
            callBack()
        }
    }
    
    internal func getHighestIndex(filePath : URL)-> Int{
        var index = 0
        do{
            let directoryContents = try FileManager.default.contentsOfDirectory(at: filePath, includingPropertiesForKeys: nil, options: [])
            let asdFiles = directoryContents.filter{ $0.pathExtension == "asd" }
            for asdFile in asdFiles{
                print(asdFile.lastPathComponent)
                let asdFileNameComponents = asdFile.lastPathComponent.characters.split{$0 == "_"}.map(String.init)
                index = Int(asdFileNameComponents.first!)! > index ? Int(asdFileNameComponents.first!)! : index
            }
        }catch{
            print("Error in IO")
        }
        return index
    }
}
