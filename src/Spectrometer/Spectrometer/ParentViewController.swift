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
    var spectrumDataList : [SpectrumData] = [SpectrumData]()
    var whiteRefrenceBefore : FullRangeInterpolatedSpectrum?
    var whiteRefrenceAfter : FullRangeInterpolatedSpectrum?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstPage = self.storyboard!.instantiateViewController(withIdentifier: "StartTestSeriesViewController") as! StartTestSeriesViewController
        firstPage.pageContainer = self
        self.setViewControllers([firstPage], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    func goToNextPage(spectrum : FullRangeInterpolatedSpectrum, whiteRefrenceSpectrum : FullRangeInterpolatedSpectrum)
    {
        spectrumDataList.append(SpectrumData(spectrum: spectrum, whiteRefrence: whiteRefrenceSpectrum))
        goToNextPage()
    }
    
    func goToNextPage(spectrum : FullRangeInterpolatedSpectrum)
    {
        spectrumDataList.append(SpectrumData(spectrum: spectrum))
        goToNextPage()
    }
    
    func goToNextPage()
    {
        if(measurmentFinished()){
            addWhiteRefrenceToSpectrumArray()
            showViewControllerWithIdentifier(identifier: "FinishTestSeriesViewController")
            return
        }
        
        switch(measurmentSettings!.whiteRefrenceSetting){
        case .TakeBefore:
            if(whiteRefrenceBefore == nil)
            {
                showViewControllerWithIdentifier(identifier: "WhiteRefrenceViewController")
            }
            else
            {
                showViewControllerWithIdentifier(identifier: "FastMeasurmentViewController")
            }
        case .TakeBeforeAndAfter:
            if(whiteRefrenceBefore == nil || spectrumDataList.count >= measurmentSettings!.measurementCount)
            {
                showViewControllerWithIdentifier(identifier: "WhiteRefrenceViewController")
            }
            else
            {
                showViewControllerWithIdentifier(identifier: "FastMeasurmentViewController")
            }
        case .TakeAfter:
            if(spectrumDataList.count < measurmentSettings!.measurementCount)
            {
                showViewControllerWithIdentifier(identifier: "FastMeasurmentViewController")
            }
            else
            {
                showViewControllerWithIdentifier(identifier: "WhiteRefrenceViewController")
            }
        }
    }
    
    func addWhiteRefrenceToSpectrumArray()
    {
        switch measurmentSettings!.whiteRefrenceSetting {
        case .TakeBefore:
            for spetrumData in spectrumDataList
            {
                spetrumData.whiteRefrence = whiteRefrenceBefore
            }
        case .TakeBeforeAndAfter:
            for spetrumData in spectrumDataList
            {
                //todo: take average of before and after wr
                spetrumData.whiteRefrence = whiteRefrenceBefore
            }
        case .TakeAfter:
            for spetrumData in spectrumDataList
            {
                spetrumData.whiteRefrence = whiteRefrenceAfter
            }
        }
    }
    
    func showViewControllerWithIdentifier(identifier : String){
        print("show: "+identifier)
        let nextModal = self.storyboard!.instantiateViewController(withIdentifier: identifier) as! BaseMeasurementModal
        nextModal.pageContainer = self
        setViewControllers([nextModal], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    func measurmentFinished() -> Bool{
        switch(measurmentSettings!.whiteRefrenceSetting){
        case .TakeBefore:
            return spectrumDataList.count >= measurmentSettings!.measurementCount
        default:
            return spectrumDataList.count >= measurmentSettings!.measurementCount && whiteRefrenceAfter != nil
        }
    }
}

class MeasurmentSettings{
    var measurementCount : Int
    var whiteRefrenceSetting : WhiteRefrenceSettings
    var path :URL
    var fileName : String
    
    init(measurementCount : Int, whiteRefrenceSetting : WhiteRefrenceSettings, path : URL, fileName : String){
        self.measurementCount = measurementCount
        self.whiteRefrenceSetting = whiteRefrenceSetting
        self.path = path
        self.fileName = fileName
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

enum WhiteRefrenceSettings{
    case TakeBefore
    case TakeBeforeAndAfter
    case TakeAfter
}
