//
//  File.swift
//  
//
//  Created by Vagner Oliveira on 03/06/23.
//

import Foundation

protocol NSAPIConfigurationSessionDelegate {
    var configurationSession:URLSessionConfiguration { get }
    func checkWaitingForConnectivity(withURL url: URL?)
}

/// Essa classe é o start da aplicação e contem as configurações iniciais
public class NSAPIConfiguration {
    public static var shared = NSAPIConfiguration()
    
    var delegate: NSAPIConfigurationSessionDelegate?
    
    var configurationSession: URLSessionConfiguration { delegate?.configurationSession ?? .noBackgroundTask }
    
    var apiConnection: NSAPIURLSession {
        return NSAPIURLSession(delegate: self)
    }
    
    private(set) var baseUrl = ""
    
    public func setBaseUrl(_ url:String) {
        self.baseUrl = url
    }
    
    private(set) var port = 0
    
    public func setPort(_ port:Int) {
        self.port = port
    }
    
    
}

extension NSAPIConfiguration: NSURLSessionConnectivity {
    func checkWaitingForConnectivity(withURL url: URL?) {
        delegate?.checkWaitingForConnectivity(withURL: url)
    }
}


 
