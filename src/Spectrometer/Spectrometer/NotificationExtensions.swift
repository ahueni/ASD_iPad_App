//
//  NotificationExtensions.swift
//  Spectrometer
//
//  Created by raphi on 06.03.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let reloadSpectrometerConfig = Notification.Name("reloadSpectrometerConfig")
    static let darkCurrentTimer = Notification.Name("darkCurrentTimer")
    static let whiteReferenceTimer = Notification.Name("whiteReferenceTimer")
}
