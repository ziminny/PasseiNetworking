//
//  NSAPIFactory.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 13/11/23.
//

import Foundation

/// Implementação padrão da fábrica de serviços HTTP.
public struct NSHTTPServiceFactory {
    
    public static func makeHttpService() -> NSAPIService {
        let apiRequester = NSAPIRequester()
        let http = NSAPIService(apiRequester: apiRequester)
        return http
    }
    
    public static func makeSocketService() -> NSSocketManager {
        let socket = NSSocketManager()
        return socket
    }
 
}
 

