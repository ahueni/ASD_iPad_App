//
//  BackgroundFileWriteManager.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 28.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class FileWriteManager{
    // serial Queue to only queue one file at once
    let serialQueue = DispatchQueue(label: "fileWriteQueue")
    // Singleton instance
    static let sharedInstance = FileWriteManager()
    private init() { }
    
    func addToQueueRaw(spectrums : [FullRangeInterpolatedSpectrum], settings: MeasurmentSettings)
    {
        serialQueue.sync {
            for spectrum in spectrums
            {
                let relativeFilePath = createNewFilePath(settings: settings)
                let fileWriter = IndicoWriter(path: relativeFilePath, settings: settings)
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
                let fileWriter = IndicoWriter(path: relativeFilePath, settings: settings)
                fileWriter.writeReflectance(spectrum: spectrum, whiteRefrenceSpectrum: whiteRefrenceSpectrum)
            }
        }
    }
    
    func addToQueueRadiance(spectrums : [FullRangeInterpolatedSpectrum], radianceCalibrationFiles: RadianceCalibrationFiles, settings: MeasurmentSettings, fileSuffix :String = "")
    {
        serialQueue.sync {
            for spectrum in spectrums
            {
                let relativeFilePath = createNewFilePath(settings: settings, fileSuffix: fileSuffix)
                let fileWriter = IndicoWriter(path: relativeFilePath, settings: settings)
                fileWriter.writeRadiance(spectrum: spectrum, radianceCalibrationFiles: radianceCalibrationFiles)
            }
        }
    }
    
    func createNewFilePath(settings: MeasurmentSettings, fileSuffix :String = "") -> String{
        let index = getHighestIndex(filePath: settings.path, fileName: settings.fileName) + 1
        // padd the index to 5 with zeros -> Example: test_00001.asd
        let fileName = settings.fileName + fileSuffix + String(format: "_%05d", index) + ".asd"
        let relativeFilePath = settings.path.appendingPathComponent(fileName).relativePath
        return relativeFilePath
    }
    
    func addFinishWritingCallBack(callBack: ()->Void){
        serialQueue.sync {
            callBack()
        }
    }
    
    internal func getHighestIndex(filePath : URL, fileName: String)-> Int{
        var index = 0
        do{
            // read all files and filter by asd extension
            let directoryContents = try FileManager.default.contentsOfDirectory(at: filePath, includingPropertiesForKeys: nil, options: [])
            let asdFiles = directoryContents.filter{ $0.pathExtension == "asd" }
            for asdFile in asdFiles{
                // remove extension
                let fileNameWithoutExtension = asdFile.deletingPathExtension()
                // split by _
                let asdFileNameComponents = fileNameWithoutExtension.lastPathComponent.characters.split{$0 == "_"}.map(String.init)
                if(asdFileNameComponents.first == fileName){
                    // get index
                    let fileIndex = Int(asdFileNameComponents.last!)!
                    //compare with currentIndex and take higher
                    index = fileIndex > index ? fileIndex : index
                }
            }
        }catch{
            print("Error in IO")
            //return 0 or highest found index if something went wrong
        }
        return index
    }
}
