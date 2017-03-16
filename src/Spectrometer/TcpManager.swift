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
    
    private init() { }
    
    private var client: TCPClient!
    var isConnected: Bool {
        get {
            return client != nil
        }
    }
    
    func connect(internetAdress: InternetAddress) -> Bool {
        // conntect to spectrometer
        do {
            client = try TCPClient(address: internetAdress, connectionTimeout: 8)
            var recievedBytes:Int = 0
            while recievedBytes < 60 {
                let part = try client?.receiveAll()
                recievedBytes += (part?.count)!
                print(try part?.toString() ?? "recieved no printable data")
            }
        } catch {
            return false
        }
        return true
    }
    
    func disconnect() -> Void {
        do {
            try client?.close()
            client = nil
        } catch {
            print("Error \(error)")
            client = nil
        }
    }
    
    func sendCommand(command: Command) throws -> [UInt8] {
        print("CommandSent: '" + command.getCommandString() + "'")
        var data:[UInt8] = []
        
        // send command
        try client.send(bytes: command.getCommandString().toBytes())
        
        // wait until all bytes are recieved
        while data.count < command.size {
            let part: [UInt8]? = try client.receive(maxBytes: 50)
            data += part!
        }
        return data
    }
    
}
