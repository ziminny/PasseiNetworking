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
    func checkWaitingForConnectivity(withURL url:URL?)
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
        delegate.checkWaitingForConnectivity(withURL: task.response?.url)
        
        if delegate.configurationSession == .noBackgroundTask {
            // Sempre que chama esse metodo ( session.invalidateAndCancel() ) o metodo urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?)
            // é chamado com o parametro didBecomeInvalidWithError nil
            // TODO: Atenção, esse metodo cancela todas as requisicoes que fazem parte da mesma session
            // session.invalidateAndCancel()
            
            // Cancela somente a requisicao atual e não dispara o metodo urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?)
            // gera um erro do tipo cancelled
            task.cancel()
        }
       
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
         // Erro do lado do cliente
    }
    
    public func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if let error = error as? URLError {
            switch error.code {
            case .notConnectedToInternet:
                print("notConnectedToInternet")
                break;
            case .networkConnectionLost:
                print("networkConnectionLost")
                break;
            default:
                break;
            }
        }
    }
    
 
    
}

