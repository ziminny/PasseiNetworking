//
//  NSHTTPServiceFactory.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 13/11/23.
//

import Foundation

/// Implementação padrão da fábrica de serviços HTTP.
public struct NSHTTPServiceFactory: Sendable {
    
    public init() {}
    
    public func makeHttpService() -> NSAPIService {
        let apiRequester = NSAPIRequester()
        let http = NSAPIService(apiRequester: apiRequester)
        return http
    }
    
    public func makeSocketService() -> NSSocketManager {
        let socket = NSSocketManager.shared
        return socket
    }
 
}
 

