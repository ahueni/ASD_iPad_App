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
    
    init(hostname: String, port: Int) {
        address = InternetAddress(hostname: hostname, port: Port(port))
    }
    
    func connect() -> Bool {
        
        do {
            client = try TCPClient(address: address, connectionTimeout: 5)
            var recData = 0
            while recData < initByteSize {
                let recPart = try client?.receiveAll()
                recData += (recPart?.count)!
                print(try recPart?.toString() ?? "recieved no printable data")
            }
        } catch {
            print("Error \(error)")
            connectState = false
            return false
        }
        
        connectState = true
        return true
        
    }
    
    func close() -> Void {
        connectState = false
        do {
            try client?.close()
        } catch {
            print("Error \(error)")
        }
    }
    
    func sendCommand(command: Command) -> [UInt8] {
        
        print("CommandSent: '" + command.getCommandString() + "'")
        var array:[UInt8] = []
        
        do {
            try client?.send(bytes: command.getCommandString().toBytes())
            
            let data = try client?.receive(maxBytes: command.size)
            array += data!
            print("CommandSize: " + command.size.description + " | " + array.count.description)
            
            
            //var recData = 0
            //while recData < command.size {
            //    let recPart: [UInt8]? = try client?.receiveAll()
            //    array += recPart!
            //    recData += (recPart?.count)!
            //}
        } catch {
            print("Error \(error)")
        }
        
        return array
        
    }
    
}
