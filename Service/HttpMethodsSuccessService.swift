//
//  HttpMethodsSuccessService.swift
//  PasseiNetworking-Unit-Tests
//
//  Created by vagner reis on 16/10/24.
//

import Foundation
@testable import PasseiNetworking

struct HttpMethodsSuccessService: NSServiceProtocol {
    
    var urlSession = MockURKSession.shared
    var factory: any NSHTTPServiceFactoryProtocol
    
    init(withFactory factory: any NSHTTPServiceFactoryProtocol) {
        self.factory = factory
        urlSession.useProxyman = false
    }
    
    func testSuccessWithoutAuthGET() async throws -> MockData? {
                
        let service = factory.makeHttpService(apiURLSession: urlSession)
        
        let parameters = NSParameters(path: Paths.test)
        
        return try await service.fetchAsync(MockData.self, nsParameters: parameters)
        
    }
    
    func testSuccessWithoutAuthPOST() async throws -> MockData? {
                
        let service = factory.makeHttpService(apiURLSession: urlSession)
        
        let parameters = NSParameters(method: .POST, path: Paths.test)
        
        return try await service.fetchAsync(MockData.self, nsParameters: parameters)
        
    }
    
    func testSuccessWithoutAuthPUT() async throws -> MockData? {
                
        let service = factory.makeHttpService(apiURLSession: urlSession)
        
        let parameters = NSParameters(method: .PUT, path: Paths.testQueryString)
        
        return try await service.fetchAsync(MockData.self, nsParameters: parameters)

        
    }
    
    func testSuccessWithoutAuthDELETE() async throws -> MockData? {
                
        let service = factory.makeHttpService(apiURLSession: urlSession)
        
        let parameters = NSParameters(method: .DELETE, path: Paths.testParam)
        
        return try await service.fetchAsync(MockData.self, nsParameters: parameters)

    }
    
}
