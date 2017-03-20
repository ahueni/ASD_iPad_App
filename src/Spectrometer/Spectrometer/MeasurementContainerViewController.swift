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
    
    var popOverDismissedDelegate: PopOverDismissedDelegate!
    
    // store selectedForeOptic for radiance calculation
    var selectedForeOptic : CalibrationFile? // only used in radiance
    
    // indicator to save measurement mode
    var measurmentMode : MeasurementMode!
    
    // in this list all pages are stored (start, settings, whiteref, target and finish)
    var pages: [ModalPage] = []
    
    // set initial index to -1
    var currentIndex = -1
    
    // return current page
    var currentPage : ModalPage {
        get {
            return pages[currentIndex]
        }
    }
    
    // load initial measurement settings for start page
    var measurmentSettings : MeasurmentSettings{
        get {
            let measurmentSettings = UserDefaults.standard.data(forKey: "MeasurmentSettings")
            let loadedSettings = NSKeyedUnarchiver.unarchiveObject(with: measurmentSettings!) as! MeasurmentSettings
            return loadedSettings
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create initial page
        pages.append(ModalPage())
        goToNextPage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        popOverDismissedDelegate.didDismiss()
    }
    
    func goToNextPage()
    {
        // move to next page if available otherwise show finish page
        currentIndex += 1
        if(currentIndex >= pages.count) {
            showViewControllerWithIdentifier(page: FinishPage())
        }
        else {
            showViewControllerWithIdentifier(page: currentPage)
        }
    }
    
    func showViewControllerWithIdentifier(page: ModalPage) {
        // instantiate next page and move to next page
        let nextModal = self.storyboard!.instantiateViewController(withIdentifier: page.pageIdentifier) as! BaseMeasurementModal
        // set container from next page to the actual container
        nextModal.pageContainer = self
        setViewControllers([nextModal], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
}
