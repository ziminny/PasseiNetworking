//
//  NSAPIUrlSession.swift
//  PasseiNetworking
//
//  Created by Humberto Rodrigues on 06/11/23.
//

import Foundation

/// Comunicar que a conexão está sendo aguardada para a NSAPIService
protocol NSURLSessionConnectivity {
    func checkWaitingForConnectivity()
}

public class NSAPIURLSession: NSObject, URLSessionTaskDelegate {
    var delegate: NSURLSessionConnectivity
    
    init(delegate: NSURLSessionConnectivity) {
        self.delegate = delegate
    }

    var session:URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.allowsCellularAccess = true
        configuration.allowsExpensiveNetworkAccess = true
        configuration.allowsConstrainedNetworkAccess = true
        configuration.httpAdditionalHeaders = HTTPHeader.headerDict
        
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        delegate.checkWaitingForConnectivity()
        minimumTimeoutToCancelSession()
    }
    
    public func minimumTimeoutToCancelSession() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.session.invalidateAndCancel()
        }
    }
}
