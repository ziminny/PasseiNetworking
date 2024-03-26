//
//  NSAPIURLSession.swift.swift
//  PasseiNetworking
//
//  Created by Humberto Rodrigues on 06/11/23.
//

import Foundation
import Network

/// Protocolo utilizado para comunicar que a conexão está sendo aguardada pela `NSAPIService`.
protocol NSURLSessionConnectivity: AnyObject {
    /// Configuração de sessão URL para a conexão.
    var configurationSession: URLSessionConfiguration { get }
    
    /// Verifica se a conexão está aguardando conectividade.
    /// - Parameter url: URL associada à tarefa.
    func checkWaitingForConnectivity(withURL url: URL?)
}

extension NSURLSessionConnectivity {
    /// Configuração de sessão URL padrão quando não é uma tarefa em segundo plano.
    var configurationSession: URLSessionConfiguration { .noBackgroundTask }
}

/// Classe que lida com a sessão URL para a NSAPI.
internal class NSAPIURLSession: NSObject{
    
    internal static var shared = NSAPIURLSession()
    
    /// Delegado para comunicação de conectividade.
    internal weak var delegate: NSURLSessionConnectivity?

    /// Sessão URL utilizada para as solicitações da NSAPI.
    internal var session: URLSession {
        return privateQueue.sync {
            return URLSession(configuration: delegate?.configurationSession ?? .noBackgroundTask, delegate: self, delegateQueue: nil)
        }
    }
    
    internal var privateQueue = DispatchQueue(label: "com.passeiNetworking.delegate")
    
    override private init() {
        super.init()
    }

}

extension NSAPIURLSession: URLSessionTaskDelegate, URLSessionDelegate  {
    
    /// Função chamada quando uma tarefa está esperando por conectividade.
    public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        delegate?.checkWaitingForConnectivity(withURL: task.response?.url)
        
        // Cancela a tarefa se não estiver em segundo plano
        if let configuration = delegate?.configurationSession, configuration == .noBackgroundTask {
            task.cancel()
        }
    }
    
}


