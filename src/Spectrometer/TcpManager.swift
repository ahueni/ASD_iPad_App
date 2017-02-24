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
    var aquireUpdateProtocol : AquireUpdateProtocol?
    
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
            let start = NSDate()
            try client?.send(bytes: command.getCommandString().toBytes())
            let end = NSDate();
            print(NSString(format: "First: %.2f",start.timeIntervalSinceNow));
            
            let start2 = NSDate()
            var recData = 0
            while recData < command.size {
                let recPart: [UInt8]? = try client?.receive(maxBytes: 200) //try client?.receiveAll()
                array += recPart!
                recData += (recPart?.count)!
                aquireUpdateProtocol?.update(percentageReceived: Int(Double(recData)/Double(command.size) * 100))
                print("Emfpangen: "+Int(Double(recData)/Double(command.size) * 100).description)
            }
            print(NSString(format: "Second: %.2f",start.timeIntervalSinceNow));
            
        } catch {
            print("Error \(error)")
        }
        
        return array
        
    }
    
}
