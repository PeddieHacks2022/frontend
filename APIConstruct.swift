//
//  APIConstruct.swift
//  FitForm
//
//  Created by Anish Aggarwal on 2022-08-20.
//

import UIKit
import Network

class APIConstruct {

    static var connection: NWConnection?
    static var hostUDP: NWEndpoint.Host = "192.168.2.100"
    static var portUDP: NWEndpoint.Port = 8001
    static var host: String = "http://192.168.2.100:8000"
    

    static func initialize() {

        // Hack to wait until everything is set up
        var x = 0
        while(x<1000000000) {
            x+=1
        }
        connectToUDP(APIConstruct.hostUDP,APIConstruct.portUDP)
    }

    static func connectToUDP(_ hostUDP: NWEndpoint.Host, _ portUDP: NWEndpoint.Port) {
        // Transmited message:
        let messageToUDP = "Test message"

        APIConstruct.connection = NWConnection(host: APIConstruct.hostUDP, port: APIConstruct.portUDP, using: .udp)

        APIConstruct.connection?.stateUpdateHandler = { (newState) in
            print("This is stateUpdateHandler:")
            switch (newState) {
                case .ready:
                    print("State: Ready\n")
                    APIConstruct.sendUDP(messageToUDP)
                    APIConstruct.receiveUDP()
                case .setup:
                    print("State: Setup\n")
                case .cancelled:
                    print("State: Cancelled\n")
                case .preparing:
                    print("State: Preparing\n")
                default:
                    print("ERROR! State not defined!\n")
            }
        }

        APIConstruct.connection?.start(queue: .global())
    }

    static func sendUDP(_ content: Data) {
        print(APIConstruct.connection)
        APIConstruct.connection?.send(content: content, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            if (NWError == nil) {
                print("Data was sent to UDP")
            } else {
                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            }
        })))
    }

    static func sendUDP(_ content: String) {
        let contentToSendUDP = content.data(using: String.Encoding.utf8)
        print(contentToSendUDP)
        print(APIConstruct.connection)
        APIConstruct.connection?.send(content: contentToSendUDP, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            if (NWError == nil) {
                print("Data was sent to UDP")
            } else {
                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            }
        })))
        
    }

    static func receiveUDP() {
        APIConstruct.connection?.receiveMessage { (data, context, isComplete, error) in
            if (isComplete) {
                print("Receive is complete")
                if (data != nil) {
                    let backToString = String(decoding: data!, as: UTF8.self)
                    print("Received message: \(backToString)")
                } else {
                    print("Data == nil")
                }
            }
        }
    }
    /// Authenticate with API and login
    static func login(loginInfo: LoginInfo) async {
        
        guard let encoded = try? JSONEncoder().encode(loginInfo) else {
            
            print("Failed to encode login info")
            return
        }
        print(APIConstruct.host+"/signin")
        let url = URL(string: APIConstruct.host+"/signin")!
        var request = URLRequest(url:url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            print(encoded)
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }

            

            
        }
        catch {
            print("Login Failed")
        }
        
    }
}
struct LoginInfo : Codable {
    var email = ""
    var password = ""
}
struct RegisterInfo : Codable {
    var name = ""
    var email = ""
    var password = ""
}
