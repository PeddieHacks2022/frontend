//
//  APIConstruct.swift
//  FitForm
//
//  Created by Anish Aggarwal on 2022-08-20.
//

import UIKit
import Network

class APIConstruct {
    

    var connection: NWConnection?
    var hostUDP: NWEndpoint.Host = "192.168.2.100"
    var portUDP: NWEndpoint.Port = 8001
    var host: String = "http://192.168.2.100:8000"
    var sessionID = -1
    var reps = 0
    var workoutId = -1
    

    func initialize() {
        connectToUDP(hostUDP,portUDP)
    }

    func connectToUDP(_ hostUDP: NWEndpoint.Host, _ portUDP: NWEndpoint.Port) {
        // Transmited message:
        let messageToUDP: String = String(sessionID)+" "+String(workoutId)

        self.connection = NWConnection(host: hostUDP, port: portUDP, using: .udp)

        self.connection?.stateUpdateHandler = { (newState) in
            print("This is stateUpdateHandler:")
            switch (newState) {
                case .ready:
                    print("State: Ready\n")
                self.sendUDP(messageToUDP)
                self.receiveUDP()
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

        connection?.start(queue: .global())
    }

    func sendUDP(_ content: Data) {
        connection?.send(content: content, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            if (NWError == nil) {
                //print("Data was sent to UDP")
            } else {
                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            }
        })))
    }

    func sendUDP(_ content: String) {
        let contentToSendUDP = content.data(using: String.Encoding.utf8)
        connection?.send(content: contentToSendUDP, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            if (NWError == nil) {
                //print("Data was sent to UDP")
            } else {
                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            }
        })))
        
    }

    func receiveUDP() {
        connection?.receiveMessage { (data, context, isComplete, error) in
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
    func login(info: SignInfo) async {
        
        guard let encoded = try? JSONEncoder().encode(info) else {
            
            print("Failed to encode login info")
            return
        }
        print(host+"/signin")
        let url = URL(string: host + "/signin")!
        var request = URLRequest(url:url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            print(encoded)
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                    sessionID = responseJSON["ID"] as! Int
                }

            

            
        }
        catch {
            print("Login Failed")
        }
        
    }
    
    func register(info: SignInfo) async {
        guard let encoded = try? JSONEncoder().encode(info) else {
            print("Failed to encode register info")
            return
        }
        let url = URL(string: host+"/signup")!
        var request = URLRequest(url:url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            print(encoded)
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                    sessionID = responseJSON["ID"] as! Int
                }
        }
        catch {
            print("Login Failed")
        }
        
        
    }
    func createWorkout(data: WorkoutTemplate) async {
        guard let encoded = try? JSONEncoder().encode(data) else {
            
            print("Failed to encode login info")
            return
        }
        print(data.weight)
        print(data.name)
        print(data.type)
        let url = URL(string: host + "/user/" + String(sessionID) + "/workout")!
        var request = URLRequest(url:url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            print(encoded)
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            print(data)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                } else {
                    print ("Response Failed")
                }
        }
        catch {
            print("Create workout failed")
        }
    }
    func getReps() async {
        guard let encoded = try? JSONEncoder().encode(["ID":sessionID]) else {
            print("Failed to encode register info")
            return
        }
        let url = URL(string: host + "/udp/update")!
        var request = URLRequest(url:url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        do {
            let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    var change = responseJSON["change"] as! String
                    if change != "nothing"{
                        reps+=1
                        print(reps)
                    }
                }
        }
        
        catch {
            print("Login Failed")
        }
        
    }
    func getWorkouts() async {
        let url = URL(string: host + "/user/" + String(sessionID) + "/workout")!
        var request = URLRequest(url:url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        var finalResult: [WorkoutRequest] = [];
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
            }
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode([String: [WorkoutRequest]].self, from: data!)
                print(result)
                finalResult = result["workouts"]!
            } catch {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }

    func getRoutines() async {
        let url = URL(string: host + "/user/" + String(sessionID) + "/routine")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"

        /* var finalResult: RoutineRequest = []; */
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error)")
            }
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            let decoder = JSONDecoder()
            
            do {
                let result = try decoder.decode(RoutineRequest.self, from: data!)
                print(result)
            } catch {
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
    
}

var construct = APIConstruct()
class APIData: Codable{
    
}
class WithSession: APIData{
    var sessionID: Int
    var data: APIData
    init(sessionID:Int,data:APIData) {
        self.sessionID = sessionID
        self.data = data
        super.init()
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    
}

class SignInfo : Encodable {
    var name = ""
    var email = ""
    var password = ""
}
