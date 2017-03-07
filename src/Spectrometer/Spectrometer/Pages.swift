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

class RawPage : ModalPage{
    override init(){
        super.init()
        pageIdentifier = "RawSettingsViewController"
    }
}

class ReflectancePage : ModalPage{
    override init(){
        super.init()
        pageIdentifier = "ReflectanceSettingsViewController"
    }
}

class RadiancePage : ModalPage{
    override init(){
        super.init()
        pageIdentifier = "RadianceSettingsViewController"
    }
}

class WhiteReferencePage : ModalPage{
    var whiteReferenceCount : Int
    var whiteReferenceDelay : Int
    var whiteRefrenceEnum : WhiteReferenceEnum
    
    init(whiteReferenceCount : Int, whiteReferenceDelay : Int, whiteRefrenceEnum : WhiteReferenceEnum){
        self.whiteReferenceCount = whiteReferenceCount
        self.whiteReferenceDelay = whiteReferenceDelay
        self.whiteRefrenceEnum = whiteRefrenceEnum
        super.init()
        self.pageIdentifier = "WhiteRefrenceViewController"
    }
}

class WhiteReferenceReflectancePage : WhiteReferencePage{
    init(){
        super.init(whiteReferenceCount: 1, whiteReferenceDelay: 0, whiteRefrenceEnum: .Before)
        self.pageIdentifier = "ReflectanceWhiteRefrenceViewController"
    }
}

class WhiteReferenceRadiancePage : WhiteReferencePage{
    override init(whiteReferenceCount : Int, whiteReferenceDelay : Int, whiteRefrenceEnum : WhiteReferenceEnum){
        super.init(whiteReferenceCount: whiteReferenceCount, whiteReferenceDelay: whiteReferenceDelay, whiteRefrenceEnum : whiteRefrenceEnum)
        self.pageIdentifier = "RadianceWhiteRefrenceViewController"
    }
}

class TargetPage : ModalPage{
    let targetCount : Int
    let targetDelay : Int
    let takeDarkCurrent : Bool
    let dataType : DataType
    
    init(targetCount : Int, targetDelay : Int, takeDarkCurrent : Bool = true, dataType : DataType){
        self.targetCount = targetCount
        self.targetDelay = targetDelay
        self.takeDarkCurrent = takeDarkCurrent
        self.dataType = dataType
        super.init()
        self.pageIdentifier = "TargetViewController"
    }
}

class FinishPage : ModalPage{
    override init() {
        super.init()
        self.pageIdentifier = "FinishTestSeriesViewController"
    }
}
