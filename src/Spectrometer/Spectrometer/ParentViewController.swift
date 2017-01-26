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
    var currentPageIndex = 0
    var measurmentSettings : MeasurmentSettings = MeasurmentSettings()
    var spectrums: [(whiteRefrenceSpectrum :FullRangeInterpolatedSpectrum, spectrum: FullRangeInterpolatedSpectrum)] = [(FullRangeInterpolatedSpectrum,FullRangeInterpolatedSpectrum)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstPage = self.storyboard?.instantiateViewController(withIdentifier: "TestSeriesViewController") as! TestSeriesViewController
        firstPage.pageContainer = self
        self.setViewControllers([firstPage], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    func goToNextPage(spectrum : (FullRangeInterpolatedSpectrum, FullRangeInterpolatedSpectrum))
    {
        spectrums.append(spectrum)
        goToNextPage()
    }
    
    func goToNextPage()
    {
        currentPageIndex += 1
        
        //all measurements are done
        if(measurmentSettings.whiteRefrenceSetting.hashValue == 0)
        {
            if(currentPageIndex > 1)
            {
                showFinishScreen()
            }
            //go to next measurement page
            else{
            let fastMeasurementViewController = self.storyboard?.instantiateViewController(withIdentifier: "FastMeasurmentViewController") as! FastMeasurmentViewController
            fastMeasurementViewController.pageContainer = self
            setViewControllers([fastMeasurementViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            }
        }
        else
        {
            //all measurements are done
            if(currentPageIndex > (measurmentSettings.measurementCount)){
                showFinishScreen()
            } //go to next measurement
            else{
                let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
                
                pageContentViewController.pageContainer = self
                pageContentViewController.strTitle = "Messung "+currentPageIndex.description
                setViewControllers([pageContentViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            }
        }
    }
    
    func showFinishScreen(){
        let finishViewController = self.storyboard?.instantiateViewController(withIdentifier: "FinishTestSeriesViewController") as! FinishTestSeriesViewController
        finishViewController.pageContainer = self
        setViewControllers([finishViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
}

class MeasurmentSettings{
    var measurementCount = 10
    var whiteRefrenceSetting : WhiteRefrenceSettings = WhiteRefrenceSettings.TakeBeforeMesurement
    var path :URL? = nil
    var fileName = ""
}

enum WhiteRefrenceSettings{
    case TakeOnce
    case TakeBeforeMesurement
}
