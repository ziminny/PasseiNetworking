//
//  NSAPIUrlSession.swift
//  PasseiNetworking
//
//  Created by Humberto Rodrigues on 06/11/23.
//

import Foundation
import Network

/// Comunicar que a conexão está sendo aguardada para a NSAPIService
protocol NSURLSessionConnectivity {
    
    var configurationSession:URLSessionConfiguration { get }
    func checkWaitingForConnectivity()
}

extension NSURLSessionConnectivity {
    var configurationSession:URLSessionConfiguration { .noBackgroundTask }
}

public class NSAPIURLSession: NSObject, URLSessionTaskDelegate,URLSessionDelegate {
    var delegate: NSURLSessionConnectivity
    
    init(delegate: NSURLSessionConnectivity) {
        self.delegate = delegate
    }

    lazy var session:URLSession = {
        return URLSession(configuration: delegate.configurationSession, delegate: self, delegateQueue: nil)
    }()
    
    
    public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        delegate.checkWaitingForConnectivity()
        // Preciso estudar sobre isso aqui
        //session.finishTasksAndInvalidate()
    }

    
}

