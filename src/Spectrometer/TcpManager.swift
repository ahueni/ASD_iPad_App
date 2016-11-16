//
//  TcpManager.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

class TcpManager {
    
    let address:InternetAddress
    let initByteSize:Int = 60
    var client: TCPClient? = nil
    var connectState: Bool = false
    let parser: SpectrumParser = SpectrumParser()
    
    init(hostname: String, port: Int) {
        address = InternetAddress(hostname: hostname, port: Port(port))
    }
    
    func connect() -> Void {
        
        do {
            client = try TCPClient(address: address, connectionTimeout: 10)
            var recData = 0
            while recData < initByteSize {
                let recPart = try client?.receiveAll()
                recData += (recPart?.count)!
                print(try recPart?.toString() ?? "recieved no printable data")
            }
        } catch {
            print("Error \(error)")
            connectState = false
        }
        
        connectState = true
        
    }
    
    func sendCommand(command: Command) -> BaseSpectrum {
        
        var array:[UInt8] = [UInt8]()
        
        do {
            try client?.send(bytes: command.getCommandString().toBytes())
            
            var recData = 0
            while recData < command.size {
                let recPart = try client?.receiveAll()
                array += recPart!
                recData += (recPart?.count)!
            }
        } catch {
            print("Error \(error)")
        }
        
        if command.command == .Version {
            return parser.parseVersion(data: array)
        }
        else if command.command == .Aquire {
            return parser.parseVersion(data: array)
        }
        
        fatalError("no parser implemented for this command")
        
    }
    
}
