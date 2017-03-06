//
//  ServiceExtensions.swift
//  Spectrometer
//
//  Created by raphi on 06.03.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation
import CoreGraphics

extension FileManager {
    // measurements root folder
    func getMeasurmentRoot() -> URL{
        let url = self.urls(for: .libraryDirectory, in: .userDomainMask)[0] as URL
        return url.resolvingSymlinksInPath()
    }
}

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
