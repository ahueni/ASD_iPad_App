//
//  BaseWhiteRefrenceViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 24.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class BaseWhiteReferenceViewController : BaseMeasurementModal{
    
    var aquireLoopOn = false // Indicates if a aquireLoop is running
    var currentSpectrum : FullRangeInterpolatedSpectrum? = nil // the actual Measurment
    var whiteRefrencePage : WhiteReferencePage! // currentPage
    
    @IBOutlet var progressBar: CustomProgressBar!
    @IBOutlet weak var startWhiteRefrenceButton: LoadingButton!
    @IBOutlet weak var nextButton: UIBlueButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        whiteRefrencePage = pageContainer.currentPage as! WhiteReferencePage
        progressBar?.initialize(total: whiteRefrencePage.whiteReferenceCount)
        
        // start aquire data
        aquireLoopOn = true
        DispatchQueue.global().async {
            while(self.aquireLoopOn){
                self.aquire()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        aquireLoopOn = false
    }
    
    func aquire() {
        // Background tasks
        currentSpectrum = CommandManager.sharedInstance.aquire(samples: (self.appDelegate.config?.sampleCount)!)
        
        DispatchQueue.main.async {
            //update ui
            self.updateLineChart(spectrum: self.currentSpectrum!)
        }
    }
    
    @IBAction func takeWhiteRefrence(_ sender: UIButton) {
        startWhiteRefrenceButton.showLoading()
        nextButton.isEnabled = false
        
        DispatchQueue.global().async {
            for i in 0...self.whiteRefrencePage.whiteReferenceCount-1
            {
                self.updateProgressBar(measurmentCount: i, statusText: "Bereite nächste Messung vor")
                sleep(UInt32(self.whiteRefrencePage.whiteReferenceDelay)) // Wait two second before starting the next measurment
                self.updateProgressBar(measurmentCount: i, statusText: "Messe...")
                self.setSpectrum()
                self.updateProgressBar(measurmentCount: i+1, statusText: "Messung beendet")
                sleep(UInt32(self.whiteRefrencePage.whiteReferenceDelay)) //Wait two second
            }
            DispatchQueue.main.async {
                self.startWhiteRefrenceButton.hideLoading()
                self.startWhiteRefrenceButton.setTitle("Retake white Refrence", for: .normal)
                self.nextButton.isEnabled = true
            }
        }
    }
    
    // Only used in subClasses
    func setSpectrum(){
    }
    
    func updateProgressBar(measurmentCount:Int, statusText:String)
    {
        if(progressBar == nil)
        {return}
        DispatchQueue.main.async {
            self.progressBar.updateProgressBar(actual: measurmentCount, statusText: statusText)
        }
    }
    
}
