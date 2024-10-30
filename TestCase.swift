//
//  TestCase.swift
//  PasseiNetworking-Unit-Tests
//
//  Created by vagner reis on 16/10/24.
//

import XCTest
import Foundation
@testable import PasseiNetworking

class TestCase: XCTestCase {
    
    var factory: MockHTTPServiceFactory?
    
    var urlSession = MockURKSession.shared
    
    var httpInterceptor: HTTPInterceptorBuilder?    
    
    override func setUpWithError() throws {
        httpInterceptor = HTTPInterceptorBuilder()
        httpInterceptor?
            .setHTTPConfiguration()
            .setInterceptorParams()
        factory = MockHTTPServiceFactory()
        urlSession.useProxyman = false
    }
    
    override func tearDownWithError() throws {
        factory = nil
        httpInterceptor = nil
        MockURLProtocol.requestHandler = nil
    }
    
}
