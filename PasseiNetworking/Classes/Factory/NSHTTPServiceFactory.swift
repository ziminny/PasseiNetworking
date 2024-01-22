//
//  NSAPIFactory.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 13/11/23.
//

import Foundation

/// Protocolo para uma fábrica de serviços HTTP.
public protocol NSHTTPServiceFactoryProtocol {
    /// Instância do serviço HTTP.
    var service: NSAPIService { get }
}

/// Protocolo para uma fábrica de serviços HTTP.
public protocol NSProxyPServiceFactoryProtocol {
    /// Instância do serviço HTTP.
    var socket: Any { get }
}

/// Implementação padrão da fábrica de serviços HTTP.
public class NSHTTPServiceFactory: NSHTTPServiceFactoryProtocol {
    
    /// Inicializador padrão.
    public init() {}
    
    /// Retorna uma instância do serviço HTTP.
    public var service: NSAPIService {
        return NSAPIService()
    }

    /// Retorna uma instância do serviço de .
    public var socket: Any {
        return "Implemet"
    }
}

