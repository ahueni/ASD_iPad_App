//
//  InstrumentControl.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

// IC
struct InstrumentControl
{
    var header: Int
    var errbyte: Int
    var detector: Int
    var cmdType: Int
    var value: Int
}
