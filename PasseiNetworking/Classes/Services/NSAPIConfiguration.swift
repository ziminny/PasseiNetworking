//
//  File.swift
//  
//
//  Created by Vagner Oliveira on 03/06/23.
//

import Foundation

/// Essa classe é o start da aplicação e contem as configurações iniciais
public class NSAPIConfiguration {
    
    public static var shared = NSAPIConfiguration()
    
    var session:URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [
            "Content-Type":"application/json",
            "Accept":"application/json"
        ]
        
        return URLSession(configuration: configuration)
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

 
