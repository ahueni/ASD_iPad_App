//
//  BackgroundFileWriteManager.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 28.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class BackgroundFileWriteManager{
    
    var isWorking : Bool = false
    let serialQueue = DispatchQueue(label: "fileWriteQueue")
    
    static let sharedInstance = BackgroundFileWriteManager()
    private init() { }
    
    func addToQueue(spectrums : [FullRangeInterpolatedSpectrum], whiteRefrenceSpectrum: FullRangeInterpolatedSpectrum? = nil, settings: MeasurmentSettings, dataType : DataType, radianceCalibrationFiles: RadianceCalibrationFiles? = nil, fileSuffix :String = "")
    {
        serialQueue.sync {
            for spectrum in spectrums
            {
                let index = getHighestIndex(filePath: settings.path) + 1
                let fileName = String(format: "%03d_", index) + settings.fileName + fileSuffix + ".asd"
                print(fileName + " queued")
                let relativeFilePath = settings.path.appendingPathComponent(fileName).relativePath
                let fileWriter = IndicoWriter(path: relativeFilePath)
                fileWriter.write(spectrum: spectrum, dataType: dataType, whiteRefrenceSpectrum: whiteRefrenceSpectrum, radianceCalibrationFiles: radianceCalibrationFiles)
            }
        }
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
