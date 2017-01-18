//
//  TestSeriesViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 18.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class TestSeriesViewController : UIViewController {
    
    var pageIndex: Int = 0
    var strTitle: String!
    var pageContainer : UIPageViewController? = nil
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        let pageContentViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        
        pageContentViewController.pageContainer = pageContainer
        let test = arc4random()
        pageContentViewController.strTitle = "Test! " + test.description
        pageContainer?.setViewControllers([pageContentViewController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
    }
    
    @IBAction func CancelButtonClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
