//
//  ViewStore.swift
//  Spectrometer
//
//  Created by raphi on 06.03.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import UIKit

class ViewStore {
    
    // prevent other instances of this class -> singelton
    private init() { }
    
    static let sharedInstance = ViewStore()
    
    // indicators to stopp or check a loop in background threads -> they have to be in a singelton
    var aquireLoop = false
    var cancelMeasurment = true
    
    // last selected mode in file view
    var lastViewMode: MeasurementMode = .Raw
    
    // instrument configuration file all informations like ip, port, base-file, lamp-file and foreoptics
    var instrumentConfiguration: SpectrometerConfig! {
        didSet {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.saveContext()
        }
    }
    
    // timer objects for dark current and white reference
    private var darkCurrentTimer:Timer?
    var darkCurrentStartTime: TimeInterval?
    
    private var whiteReferenceTimer: Timer?
    var whiteReferenceStartTime: TimeInterval?
    
    func restartDarkCurrentTimer() -> Void {
        
        if let actualDarkCurrentTimer = darkCurrentTimer {
            actualDarkCurrentTimer.invalidate()
        }
        
        darkCurrentStartTime = NSDate.timeIntervalSinceReferenceDate
        darkCurrentTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in
            NotificationCenter.default.post(name: .darkCurrentTimer, object: nil)
        })
        
    }
    
    func restartWhiteReferenceTimer() -> Void {
        
        if let actualWhiteReferenceTimer = whiteReferenceTimer {
            actualWhiteReferenceTimer.invalidate()
        }
        
        whiteReferenceStartTime = NSDate.timeIntervalSinceReferenceDate
        whiteReferenceTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {_ in
            NotificationCenter.default.post(name: .whiteReferenceTimer, object: nil)
        })
        
    }
    
    func resetTimers() -> Void {
        darkCurrentTimer = nil
        whiteReferenceTimer = nil
    }

    
    
}
