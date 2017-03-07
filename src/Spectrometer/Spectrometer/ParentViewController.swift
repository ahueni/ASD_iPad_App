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
    var reflectanceWhiteReference : FullRangeInterpolatedSpectrum! // stores the wr from the Reflectance
    
    var selectedForeOptic : CalibrationFile? // only used in radiance
    
    var measurmentMode : MeasurementMode!
    var pages = [ModalPage]()
    var currentIndex = -1
    
    var currentPage : ModalPage{
        get{
            return pages[currentIndex]
        }
    }
    
    var measurmentSettings : MeasurmentSettings{
        get
        {
            // todo: save this in parent vc and get it from there
            let measurmentSettings = UserDefaults.standard.data(forKey: "MeasurmentSettings")
            let loadedSettings = NSKeyedUnarchiver.unarchiveObject(with: measurmentSettings!) as! MeasurmentSettings
            return loadedSettings
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

enum WhiteReferenceEnum{
    case Before
    case After
}
