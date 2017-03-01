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
    
    func addToQueue(spectrums : [FullRangeInterpolatedSpectrum], whiteRefrenceSpectrum: FullRangeInterpolatedSpectrum?, loadedSettings: MeasurmentSettings, dataType : DataType, indicoCalibration: IndicoCalibration? = nil, fileSuffix :String = "")
    {
        serialQueue.sync {
            for spectrum in spectrums
            {
                let index = getHighestIndex(filePath: loadedSettings.path) + 1
                let fileName = String(format: "%03d_", index) + loadedSettings.fileName + fileSuffix + ".asd"
                print(fileName + " queued")
                let relativeFilePath = loadedSettings.path.appendingPathComponent(fileName).relativePath
                let fileWriter = IndicoWriter(path: relativeFilePath)
                let datatype : DataType
                fileWriter.write(spectrum: spectrum, dataType: dataType, whiteRefrenceSpectrum: whiteRefrenceSpectrum, indicoCalibration: indicoCalibration)
            }
        }
    }
    
    func addFinishWritingCallBack(callBack: ()->Void){
        serialQueue.sync {
            callBack()
        }
    }
    
    func getHighestIndex(filePath : URL)-> Int{
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
