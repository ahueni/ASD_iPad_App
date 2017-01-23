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
    
    var arrPageTitle: NSArray = NSArray()
    var currentPageIndex = 0
    var measurmentSettings : MeasurmentSettings = MeasurmentSettings()
    var spectrums : [FullRangeInterpolatedSpectrum] =  [FullRangeInterpolatedSpectrum]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstPage = self.storyboard?.instantiateViewController(withIdentifier: "TestSeriesViewController") as! TestSeriesViewController
        firstPage.pageContainer = self
        firstPage.measurmentSettings = measurmentSettings
        self.setViewControllers([firstPage], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    func goToNextPage(spectrum : FullRangeInterpolatedSpectrum)
    {
        spectrums.append(spectrum)
        goToNextPage()
    }
    
    func goToNextPage(){
        currentPageIndex += 1
        
        let fastMeasurementViewController = self.storyboard?.instantiateViewController(withIdentifier: "FastMeasurmentViewController") as! FastMeasurmentViewController
        fastMeasurementViewController.pageContainer = self
        setViewControllers([fastMeasurementViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)

        
        /*
        //all measurements are done
        if(currentPageIndex > (measurmentSettings.measurementCount)){
            let finishViewController = self.storyboard?.instantiateViewController(withIdentifier: "FinishTestSeriesViewController") as! FinishTestSeriesViewController
            setViewControllers([finishViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            
        } //go to next measurement
        else{
            let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
            
            pageContentViewController.pageContainer = self
            
            pageContentViewController.strTitle = "Messung "+currentPageIndex.description
            setViewControllers([pageContentViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
 */
    }
}

class MeasurmentSettings{
    var measurementCount = 10
    var whiteRefrenceSetting : WhiteRefrenceSettings = WhiteRefrenceSettings.TakeBeforeMesurement
}

enum WhiteRefrenceSettings{
    case TakeOnce
    case TakeBeforeMesurement
}
