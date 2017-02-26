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
    
    var spectrumList = [FullRangeInterpolatedSpectrum]()
    var whiteRefrenceBeforeSpectrumList = [FullRangeInterpolatedSpectrum]()
    var whiteRefrenceAfterSpectrumList = [FullRangeInterpolatedSpectrum]()
    
    var selectedForeOptic : CalibrationFile? // only used in radiance
    
    var measurmentMode : MeasurmentMode?
    var pages = [ModalPage]()
    var currentIndex = -1
    
    var currentPage : ModalPage{
        get{
            return pages[currentIndex]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pages.append(ModalPage())
        goToNextPage()
    }
    
    func goToNextPage()
    {
        currentIndex += 1
        if(currentIndex >= pages.count)
        {
            showViewControllerWithIdentifier(page: FinishPage())
        }
        else
        {
            showViewControllerWithIdentifier(page: currentPage)
        }
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
    
    init(targetCount : Int, targetDelay : Int){
        self.targetCount = targetCount
        self.targetDelay = targetDelay
        super.init()
        self.pageIdentifier = "FastMeasurmentViewController"
    }
}

class FinishPage : ModalPage{
    override init() {
        super.init()
        self.pageIdentifier = "FinishTestSeriesViewController"
    }
}

enum WhiteReferenceEnum{
    case Before
    case After
}
