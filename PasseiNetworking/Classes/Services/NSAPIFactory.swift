//
//  NSAPIFactory.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 13/11/23.
//

import Foundation

public protocol NSHTTPServiceFactoryProtocol {
     var service:NSAPIService { get }
}

public class NSHTTPServiceFactory:NSHTTPServiceFactoryProtocol {
    
    public init() {}
    
    public var service:NSAPIService {
        return NSAPIService()
    }
    
}
