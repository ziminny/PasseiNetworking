//
//  MockURKSession.swift
//  PasseiNetworking
//
//  Created by vagner reis on 13/10/24.
//

import Foundation
import PasseiNetworking

import Foundation

final class MockURKSession: NSObject, NSAPIURLSessionProtocol {
    
    static var shared = MockURKSession()
    
    nonisolated(unsafe) weak var delegate: NSURLSessionConnectivity?
    
    var useProxyman = true
    
    var session: URLSession {
        privateQueue.sync(flags: .barrier) {
            let configuration: URLSessionConfiguration = delegate?.configurationSession ?? .noBackgroundTask
            if !useProxyman {
                configuration.protocolClasses = [MockURLProtocol.self]
            }
            let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
            return session
        }
    }
    
    var privateQueue = DispatchQueue(label: "com.passeiNetworking.NSURLSessionConnectivity", qos: .background)
    
    override private init() {
        super.init()
    } 

}

extension MockURKSession: URLSessionTaskDelegate, URLSessionDelegate  {
    
    /// Função chamada quando uma tarefa está esperando por conectividade.
    public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        privateQueue.async {
            self.delegate?.checkWaitingForConnectivity(withURL: task.response?.url)
            // Cancela a tarefa se não estiver em segundo plano
            
            if let configuration = self.delegate?.configurationSession, configuration == .noBackgroundTask {
                task.cancel()
            }
        }
    }
    
}
