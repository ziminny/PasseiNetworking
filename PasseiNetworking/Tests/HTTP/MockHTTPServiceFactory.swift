//
//  MockHTTPServiceFactory.swift
//  PasseiNetworking-Unit-Tests
//
//  Created by vagner reis on 13/10/24.
//

import Foundation
@testable import PasseiNetworking

public struct MockHTTPServiceFactory: Sendable, NSHTTPServiceFactoryProtocol {
    
    private let factory: NSHTTPServiceFactory
    
    public init() {
        factory = NSHTTPServiceFactory()
    }
    
    public func makeHttpService(apiURLSession: any NSAPIURLSessionProtocol) -> PasseiNetworking.NSAPIService {
        return factory.makeHttpService(apiURLSession: apiURLSession)
    }
    
    public func makeSocketService() -> NSSocketManager {
        fatalError("Nao invoque esse emtodo")
    }
 
}
