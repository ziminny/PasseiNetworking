//
//  HttpMethodsFailuresService.swift
//  PasseiNetworking-Unit-Tests
//
//  Created by vagner reis on 16/10/24.
//

import Foundation
@testable import PasseiNetworking

struct HttpMethodsFailuresService: NSServiceProtocol {
    
    var urlSession = MockURKSession.shared
    var factory: any NSHTTPServiceFactoryProtocol
    
    init(withFactory factory: any NSHTTPServiceFactoryProtocol) {
        self.factory = factory
        urlSession.useProxyman = false
    }
    
    func testFailureWithoutAuthGET_400() async throws {
        
        let service = factory.makeHttpService(apiURLSession: urlSession)
        
        let parameters = NSParameters(path: Paths.test)
        
        let _ = try await service.fetchAsync(MockData.self, nsParameters: parameters)
        
    }
    
    func testFailureWithoutAuthGET_401() async throws {
        
        let service = factory.makeHttpService(apiURLSession: urlSession)
        
        let parameters = NSParameters(path: Paths.test)
        
        let _ = try await service.fetchAsync(MockData.self, nsParameters: parameters)
        
    }
    
    func testFailureWithoutAuthGET_403() async throws {
        
        let service = factory.makeHttpService(apiURLSession: urlSession)
        
        let parameters = NSParameters(path: Paths.test)
        
        let _ = try await service.fetchAsync(MockData.self, nsParameters: parameters)
        
    }
    
    func testFailureWithoutAuthGET_500() async throws {
        
        let service = factory.makeHttpService(apiURLSession: urlSession)
        
        let parameters = NSParameters(path: Paths.test)
        
        let _ = try await service.fetchAsync(MockData.self, nsParameters: parameters)
        
    }
    
}
