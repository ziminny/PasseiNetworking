//
//  MockURLProtocol.swift
//  PasseiNetworking-Unit-Tests
//
//  Created by vagner reis on 13/10/24.
//

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
            // Ignore caso for no proxyman
            // fatalError("Request handler is not set.")
            return
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
