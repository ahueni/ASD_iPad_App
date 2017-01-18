//
//  PageContentViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 18.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class PageContentViewController : TestSeriesViewController{
    
    
    @IBOutlet weak var PageLabel: UILabel!
    
    override func viewDidLoad()
    {
       	super.viewDidLoad()
        
        PageLabel.text = strTitle
        
    }
}
