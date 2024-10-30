//
//  MockURKSession.swift
//  PasseiNetworking
//
//  Created by vagner reis on 13/10/24.
//

import Foundation
import PasseiNetworking

import Foundation

// Classe para simular o comportamento do URLSession com uma resposta mockada
class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))? 

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError("Request handler is not set.")
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {
        // Required but doesn't need implementation for mock
    }
}


final class MockURKSession: NSObject, NSAPIURLSessionProtocol {
    
    static var shared = MockURKSession()
    
    nonisolated(unsafe) weak var delegate: NSURLSessionConnectivity?
    
    var session: URLSession {
        privateQueue.sync(flags: .barrier) {
            let configuration: URLSessionConfiguration = delegate?.configurationSession ?? .noBackgroundTask
            if let _ = ProcessInfo.processInfo.arguments.filter({ item in
                item == "use-proxyman"
            }).first {
            }
            configuration.protocolClasses = [MockURLProtocol.self]
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

public struct MockHTTPServiceFactory: Sendable {
    
    private let factory: NSHTTPServiceFactory
    
    public init() {
        factory = NSHTTPServiceFactory()
    }
    
    public func makeHttpService() -> NSAPIService {
        factory.makeHttpService(apiURLSession: MockURKSession.shared)
    }
 
}
