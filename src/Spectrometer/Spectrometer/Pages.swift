//
//  Pages.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 07.03.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

class ModalPage {
    var pageIdentifier : String
    
    init(){
        pageIdentifier = "StartTestSeriesViewController"
    }
}

class AquireMeasurmentPage : ModalPage {
    let aquireCount : Int
    let aquireDelay : Int
    
    init(aquireCount : Int, aquireDelay : Int)
    {
        self.aquireCount = aquireCount
        self.aquireDelay = aquireDelay
        super.init()
        pageIdentifier = "do not instanciate"
    }
}

class RawSettingsPage : ModalPage{
    override init(){
        super.init()
        pageIdentifier = "RawSettingsViewController"
    }
}

class ReflectanceSettingsPage : ModalPage{
    override init(){
        super.init()
        pageIdentifier = "ReflectanceSettingsViewController"
    }
}

class RadianceSettingsPage : ModalPage{
    override init(){
        super.init()
        pageIdentifier = "RadianceSettingsViewController"
    }
}

class WhiteReferenceReflectancePage : AquireMeasurmentPage{
    init(){
        super.init(aquireCount: 1, aquireDelay: 0)
        self.pageIdentifier = "ReflectanceWhiteRefrenceViewController"
    }
}

class WhiteReferenceRadiancePage : AquireMeasurmentPage{
    override init(aquireCount : Int, aquireDelay : Int){
        super.init(aquireCount: aquireCount, aquireDelay: aquireDelay)
        self.pageIdentifier = "RadianceWhiteRefrenceViewController"
    }
}

class TargetPage : AquireMeasurmentPage{
    let takeDarkCurrent : Bool
    let dataType : DataType
    
    init(targetCount : Int, targetDelay : Int, takeDarkCurrent : Bool = true, dataType : DataType){
        self.takeDarkCurrent = takeDarkCurrent
        self.dataType = dataType
        super.init(aquireCount: targetCount, aquireDelay: targetDelay)
        self.pageIdentifier = "TargetViewController"
    }
}

class FinishPage : ModalPage{
    override init() {
        super.init()
        self.pageIdentifier = "FinishTestSeriesViewController"
    }
}
