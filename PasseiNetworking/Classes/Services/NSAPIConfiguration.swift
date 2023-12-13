//
//  File.swift
//  
//
//  Created by Vagner Oliveira on 03/06/23.
//

import Foundation

protocol NSAPIConfigurationSessionDelegate {
    var configurationSession: URLSessionConfiguration { get }
    func checkWaitingForConnectivity(withURL url: URL?)
}

/// Essa classe é o start da aplicação e contem as configurações iniciais
public final class NSAPIConfiguration {
    
    public static var shared: NSAPIConfiguration = NSAPIConfiguration()
    
    public var apiKey:String? = nil
    
    internal var delegate: NSAPIConfigurationSessionDelegate?
    
    internal var configurationSession: URLSessionConfiguration { delegate?.configurationSession ?? .noBackgroundTask }
    
    private(set) var baseUrl = ""
    
    private(set) var port:Int? = nil
    
    internal var apiConnection: NSAPIURLSession {
        return NSAPIURLSession(delegate: self)
    }
    
    public func application(
        _ baseURL: String,
        _ port: Int? = nil,
        _ apiKey: String? = nil) {
            
        self.baseUrl = baseURL
        self.port = port
        self.apiKey = apiKey
            
    }
    
    private init() { }
    
}

extension NSAPIConfiguration: NSURLSessionConnectivity {
   nonisolated func checkWaitingForConnectivity(withURL url: URL?) {
        delegate?.checkWaitingForConnectivity(withURL: url)
    }
}


 
