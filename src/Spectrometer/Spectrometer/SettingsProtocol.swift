//
//  SettingsProtocol.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 28.02.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

protocol SettingsProtocol {
    func loadSettings()
    func saveSettings()
    func addPages()
}
