//
//  NSAPIFactory.swift
//  PasseiNetworking
//
//  Created by Vagner Oliveira on 13/11/23.
//

import Foundation

/// Protocolo para uma fábrica de serviços HTTP.
public protocol NSServiceFactoryProtocol {
    /// Instância do serviço HTTP.
    var httpService: NSAPIService { get }
    /// Instância do serviço de Socket.
    var socketService: NSSocketService { get }
}

/// Implementação padrão da fábrica de serviços HTTP.
public class NSHTTPServiceFactory: NSServiceFactoryProtocol {
    
    /// Inicializador padrão.
    public init() {}
    
    private lazy var lazyHTTPService: NSAPIService = {
        return NSAPIService()
    }()
    
    private lazy var lazySocketService: NSSocketService = {
        return NSSocketService()
    }()
    
    /// Retorna uma instância do serviço NSAPIService.
    public var httpService: NSAPIService { lazyHTTPService }
    
    /// Retorna uma instância do serviço de NSSocketService.
    public var socketService: NSSocketService { lazySocketService }
}

