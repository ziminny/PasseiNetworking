//
//  NSSocketManager.swift
//  AppAuth
//
//  Created by Vagner Oliveira on 07/02/24.
//

import Foundation
import SocketIO

public class NSSocketManager: NSObject {
    
    public static let shared = NSSocketManager()
    
    private var manager: SocketManager?
    
    private var socket: SocketIOClient!
    
    public func setConfiguration(_ configuration: NSSocketConfiguration) -> Self? {
        
        var completeURL: String = configuration.url
        
        if let port = configuration.port {
            completeURL = "\(configuration.url):\(port)"
        }
        
        guard let url = URL(string: completeURL) else {
            print("Erro ao pegar a url do socket")
            return nil
        }
        manager = SocketManager(socketURL: url, config: [.log(true), .extraHeaders(["authorization": "Bearer \(configuration.token)"])])
        socket = manager?.defaultSocket
        return self
    }
    
    override init() {
        super.init()
       
    }
    
    public func emit<T: Encodable>(eventName: NSSocketEmit, withMessage message: T, completion: @escaping (Error?) -> Void){
        
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(message)
            
            socket.emit(eventName.rawValue, data) {
                completion(nil)
            }
             
        } catch {
            completion(error)
        }
        
    }
    
    private func enumResult(eventName: Notification.Name.NSSocketProviderName) -> String {
          
        switch eventName {
        case .passeiOAB(let result):
            return result.rawValue
        case .passeiENEM(let result):
            return result.rawValue
        }
    }
    
    public func received<T>(eventName: Notification.Name.NSSocketProviderName, of type: T.Type, completion: @escaping (T?) -> Void)  {
        
        let enumResult = enumResult(eventName: eventName)
        
        self.socket.on(enumResult) { (data, act) in
            if let data = data as? [T], let result = data.first {
                completion(result)
            } else {
                completion(nil)
            }
        }
        
    }
    
    @discardableResult
    public func receivedPublisher<T>(eventsName: [Notification.Name.NSSocketProviderName: T.Type]) -> Self  {
      
        for (key, type) in eventsName {
            
            let enumResult = enumResult(eventName: key)
            
            self.received(eventName: key, of: type) { result in
                if let result {
                    NotificationCenter.default.post(name: Notification.Name(enumResult), object: result)
                }
            }
        }
        return self
    }
    
    
    public func connect() -> Self {
        socket.connect()
        print("Connected to Socket!")
        return self
    }
    
    public func disconnect() {
        socket.disconnect()
        print("Disconnected from Socket!")
    }
      
} 