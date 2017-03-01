//
//  FinishTestSeriesViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 18.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class FinishTestSeriesViewController : BaseMeasurementModal {
    
    @IBOutlet var checkMarkImage: UIImageView!
    @IBOutlet var successSavingLabel: UILabel!
    
    @IBOutlet var finishButton: UIBlueButton!
    
    @IBOutlet var savingLabel: UILabel!
    @IBOutlet var savingSpinner: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkMarkImage.alpha = 0
        successSavingLabel.alpha = 0
        finishedSaving()
    }
    
    /*
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let measurmentSettings = UserDefaults.standard.data(forKey: "MeasurmentSettings")
        let loadedSettings = NSKeyedUnarchiver.unarchiveObject(with: measurmentSettings!) as! MeasurmentSettings
        
        switch pageContainer!.measurmentMode! {
        case MeasurementMode.Raw:
            save(spectrums: pageContainer!.spectrumList, whiteRefrenceSpectrum: nil, loadedSettings: loadedSettings)
            break
        case MeasurementMode.Radiance:
            
            let base = InstrumentSettingsCache.sharedInstance.instrumentConfiguration.base!
            let lamp = InstrumentSettingsCache.sharedInstance.instrumentConfiguration.lamp!
            let fiberOptic = InstrumentSettingsCache.sharedInstance.selectedForeOptic!
            let indicoCalibration = IndicoCalibration(baseFile: base, lampFile: lamp, fiberOptic: fiberOptic)
            
            //save wr before
            save(spectrums: pageContainer!.whiteRefrenceBeforeSpectrumList, whiteRefrenceSpectrum: nil, loadedSettings: loadedSettings,indicoCalibration: indicoCalibration, fileSuffix: "_wrBefore")
            //save target
            save(spectrums: pageContainer!.spectrumList, whiteRefrenceSpectrum: nil, loadedSettings: loadedSettings,indicoCalibration: indicoCalibration)
            //save wr after
            save(spectrums: pageContainer!.whiteRefrenceAfterSpectrumList, whiteRefrenceSpectrum: nil, loadedSettings: loadedSettings,indicoCalibration: indicoCalibration, fileSuffix: "_wrAfter")
            break
        case MeasurementMode.Reflectance:
            save(spectrums: pageContainer!.spectrumList, whiteRefrenceSpectrum: pageContainer!.whiteRefrenceBeforeSpectrumList.first!, loadedSettings: loadedSettings)
            break
        }
    }
 */
 
    /*
    func save(spectrums : [FullRangeInterpolatedSpectrum], whiteRefrenceSpectrum: FullRangeInterpolatedSpectrum?, loadedSettings: MeasurmentSettings, indicoCalibration: IndicoCalibration? = nil, fileSuffix :String = "")
    {
        DispatchQueue.global().async {
            for i in 0...spectrums.count-1{
                let spectrumData = spectrums[i]
                let fileName = String(format: "%03d_", i) + loadedSettings.fileName + fileSuffix + ".asd"
                let relativeFilePath = loadedSettings.path.appendingPathComponent(fileName).relativePath
                let fileWriter = IndicoWriter(path: relativeFilePath)
                
                fileWriter.write(spectrum: spectrumData, whiteRefrenceSpectrum: whiteRefrenceSpectrum, indicoCalibration: indicoCalibration)
            }
            self.finishedSaving()
        }
    }
 */
    
    func finishedSaving() -> Void {
        
        DispatchQueue.main.async {
            self.finishButton.isEnabled = true
            
            self.savingLabel.isHidden = true
            self.savingSpinner.stopAnimating()
            self.savingSpinner.isHidden = true
            
            UIView.transition(with: self.checkMarkImage, duration: 1.0, options: UIViewAnimationOptions.transitionFlipFromTop, animations: {
                
                self.checkMarkImage.alpha = 1
                self.successSavingLabel.alpha = 1
                
            }, completion: nil)
            
            
        }
        
    }
    
}
