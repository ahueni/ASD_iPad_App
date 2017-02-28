//
//  TcpManager.swift
//  Spectrometer
//
//  Created by raphi on 15.11.16.
//  Copyright © 2016 YARX GmbH. All rights reserved.
//

import Foundation

class TcpManager {
    
    static let sharedInstance = TcpManager()
    
    private init() {
        
    }
    
    internal var client: TCPClient!
    internal var connectState: Bool = false
    
    func connect(internetAdress: InternetAddress) -> Bool {
        
        let initByteSize:Int = 60
        
        do {
            client = try TCPClient(address: internetAdress, connectionTimeout: 8)
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
            try client.send(bytes: command.getCommandString().toBytes())
            
            var recData = 0
            while recData < command.size {
                let recPart: [UInt8]? = try client.receiveAll()
                array += recPart!
                recData += recPart!.count
            }
            
        } catch {
            print("Error \(error)")
        }
        
        return array
        
    }
    
}
