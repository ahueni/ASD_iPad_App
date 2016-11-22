//
//  SpectrometerConfig.swift
//  Spectrometer
//
//  Created by raphi on 20.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation
import CoreData

class SpectrometerConfig : NSManagedObject {
    
    @NSManaged var ipAdress: String?
    
    func access() -> Void {
        
        do {
            
            try managedObjectContext?.save()
            
        } catch {
            
            
            
        }
        
    }
    
}
