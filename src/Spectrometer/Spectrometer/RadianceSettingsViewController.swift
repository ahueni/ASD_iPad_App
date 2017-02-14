//
//  RadianceSettingsViewController.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 14.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class RadianceSettingsViewController : BaseMeasurementModal {
    // MARK: fade DarkCurrent settings
    @IBOutlet var contentHeight: NSLayoutConstraint!
    @IBOutlet var darkCurrentContentView: UIView!
    
    // MARK: fade WhiteReferenceBefore settings
    @IBOutlet var whiteRefBeforeContentHeight: NSLayoutConstraint!
    @IBOutlet var whiteRefBeforeContentView: UIView!
    
    @IBOutlet weak var whiteRefrenceAfterHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var whiteRefrenceAfterContentView: UIView!
    
    @IBOutlet weak var whiteRefrenceBeforeCountLabel: UILabel!
    @IBOutlet weak var whiteRefrenceBeforeCountStepper: UIStepper!
    
    @IBOutlet weak var targetCountLabel: UILabel!
    @IBOutlet weak var targetCountStepper: UIStepper!
    
    @IBOutlet weak var darkCurrentSwitch: UISwitch!
    @IBOutlet weak var whiteRefrenceAfterCountLabel: UILabel!
    @IBOutlet weak var whiteRefrenceAfterCountStepper: UIStepper!
    
    @IBOutlet weak var whiteRefrenceAfterSwitch: UISwitch!
    @IBOutlet weak var whiteRefrenceBeforeSwitch: UISwitch!
    @IBAction func whiteRefrenceBeforeCountStepperValueChanged(_ sender: UIStepper) {
        whiteRefrenceAfterCountLabel.text = Int(sender.value).description
    }
    @IBAction func targetCountStepperValueChanged(_ sender: UIStepper) {
        targetCountLabel.text = Int(sender.value).description
    }
    @IBAction func whiteRefrenceAfterCountStepperValueChanged(_ sender: UIStepper) {
        whiteRefrenceAfterCountLabel.text = Int(sender.value).description
    }
    
    @IBAction func darkCurrentSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.contentHeight.constant = 100
        } else {
            self.contentHeight.constant = 0
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func whiteRefBeforeSwitch(_ sender: UISwitch) {
        if sender.isOn {
            self.whiteRefBeforeContentHeight.constant = 70
        } else {
            self.whiteRefBeforeContentHeight.constant = 0
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func whiteRefrenceAfterSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            self.whiteRefrenceAfterHeightConstraint.constant = 70
        } else {
            self.whiteRefrenceAfterHeightConstraint.constant = 0
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    override func goToNextPage() {
        pageContainer?.settings = RadianceSettings(targetCount: Int(targetCountStepper.value), targetDelay: 0, takeWhiteRefrenceBefore: whiteRefrenceBeforeSwitch.isOn, whiteRefrenceBeforeCount: Int(whiteRefrenceBeforeCountStepper.value), takeWhiteRefrenceAfter: whiteRefrenceAfterSwitch.isOn, whiteRefrenceAfterCount: Int(whiteRefrenceAfterCountStepper.value), whiteRefrenceBeforeDelay : 0, whiteRefrenceAfterDelay : 0)
    }
    
}


@IBDesignable class SettingsBox:UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundColor = UIColor.white
        
        let borderColor:UIColor = UIColor(red:0.89, green:0.89, blue:0.89, alpha:1.00)
        
        layer.borderColor = borderColor.cgColor
        
        layer.borderWidth = 1.0
        layer.cornerRadius = 2
        
        // AddHeaderRect
        let headerRect:CGRect = CGRect(x: 0, y: 0, width: layer.frame.width, height: 46)
        let headerView:UIView = UIView(frame: headerRect)
        headerView.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.98, alpha:1.00)
        headerView.layer.addBorder(edge: .bottom, color: borderColor, thickness: 1.0)
        addSubview(headerView)
        
        sendSubview(toBack: headerView)
        
        print("LAYOUT Subviews")
    }
    
}
