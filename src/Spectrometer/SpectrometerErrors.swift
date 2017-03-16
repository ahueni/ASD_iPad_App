//
//  ExceptionErrors.swift
//  Spectrometer
//
//  Created by Andreas Lüscher on 17.01.17.
//  Copyright © 2017 YARX GmbH. All rights reserved.
//

import Foundation

struct ParsingError: Error {
    
    let message: String
    
    init(message: String) {
        self.message = message
    }
    
    
}

struct SpectrometerError: Error {
    
    enum ErrorKind {
        case connectionError
        case readError
        case parsingError
    }
    
    let message: String
    let kind: ErrorKind
    
}
