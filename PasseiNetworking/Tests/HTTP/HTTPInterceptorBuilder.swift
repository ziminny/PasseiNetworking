//
//  HTTPInterceptorBuilder.swift
//  PasseiNetworking-Unit-Tests
//
//  Created by vagner reis on 16/10/24.
//

import Foundation
@testable import PasseiNetworking

final class HTTPInterceptorBuilder {
        
    private let baseURL = "http://passei-test.com"
    // Se for rodar testes em paralelo, precisa sincronizar essa variavel
    nonisolated(unsafe) private(set) var httpMethod: NSHTTPMethod?
    nonisolated(unsafe) private(set) var path: NSRawValue?
    nonisolated(unsafe) var statusCode = NSHTTPStatusCodes.ok
    
    func setHTTPConfiguration() -> Self {
        NSAPIConfiguration
            .shared
            .application(
                baseURL,
                nil,
                "iOS",
                .ptBR
            )
        
        return self
    }
    
    func setInterceptorParams() {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: self.statusCode, httpVersion: nil, headerFields: nil)!
            let mockData: Data
            
            switch self.statusCode {
            case NSHTTPStatusCodes.successRange:
                mockData = "{ \"success\": true }".data(using: .utf8)!
                break
            case NSHTTPStatusCodes.badRequest:
                mockData = "{ \"statusCode\": \(NSHTTPStatusCodes.badRequest), \"message\": \"Swif test case\" }".data(using: .utf8)!
                break
            case NSHTTPStatusCodes.forbidden:
                mockData = "{ \"statusCode\": \(NSHTTPStatusCodes.forbidden), \"message\": \"Swif test case\" }".data(using: .utf8)!
                break
            default:
                mockData = "{ }".data(using: .utf8)!
                break
            }
            
            self.httpMethod = NSHTTPMethod(rawValue: request.httpMethod)
            self.path = Paths(rawValue: request.url?.lastPathComponent)
            
            return (response, mockData)
        }
    }
    
}
