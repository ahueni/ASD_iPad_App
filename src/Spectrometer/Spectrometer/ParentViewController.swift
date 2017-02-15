//
//  ParentViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 18.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class ParentViewController : UIPageViewController {
    
    var measurmentSettings : MeasurmentSettings?
    var spectrumDataList = [FullRangeInterpolatedSpectrum]()
    var whiteRefrenceBefore = [FullRangeInterpolatedSpectrum]()
    var whiteRefrenceAfter = [FullRangeInterpolatedSpectrum]()
    
    var measurmentMode : MeasurmentMode?
    
    var pages = [ModalPage]()
    
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pages.append(ModalPage())
        goToNextPage()
    }
    
    func goToNextPage()
    {
        showViewControllerWithIdentifier(page: pages[currentIndex])
        currentIndex += 1
    }
    
    func showViewControllerWithIdentifier(page: ModalPage){
        let nextModal = self.storyboard!.instantiateViewController(withIdentifier: page.pageIdentifier) as! BaseMeasurementModal
        nextModal.pageContainer = self
        setViewControllers([nextModal], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    func measurmentFinished() -> Bool{
        return true
    }
}

class SpectrumData{
    var spectrum : FullRangeInterpolatedSpectrum
    var whiteRefrence : FullRangeInterpolatedSpectrum?
    
    init(spectrum : FullRangeInterpolatedSpectrum){
        self.spectrum = spectrum
    }
    
    init(spectrum : FullRangeInterpolatedSpectrum, whiteRefrence : FullRangeInterpolatedSpectrum){
        self.spectrum = spectrum
        self.whiteRefrence = whiteRefrence
    }
}

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
    
    init(whiteReferenceCount : Int, whiteReferenceDelay : Int){
        self.whiteReferenceCount = whiteReferenceCount
        self.whiteReferenceDelay = whiteReferenceDelay
        super.init()
        self.pageIdentifier = "WhiteRefrenceViewController"
    }
}

class WhiteReferenceReflectancePage : WhiteReferencePage{
    override init(whiteReferenceCount : Int, whiteReferenceDelay : Int){
        super.init(whiteReferenceCount: whiteReferenceCount, whiteReferenceDelay: whiteReferenceDelay)
        self.pageIdentifier = "WhiteRefrenceViewController"
    }
}

class WhiteReferenceRadiancePage : WhiteReferencePage{
    override init(whiteReferenceCount : Int, whiteReferenceDelay : Int){
        super.init(whiteReferenceCount: whiteReferenceCount, whiteReferenceDelay: whiteReferenceDelay)
        self.pageIdentifier = "WhiteRefrenceViewController"
    }
}

class TargetPage : ModalPage{
    let targetCount : Int
    let targetDelay : Int
    
    init(targetCount : Int, targetDelay : Int){
        self.targetCount = targetCount
        self.targetDelay = targetDelay
        super.init()
        self.pageIdentifier = "FastMeasurmentViewController"
    }
}
