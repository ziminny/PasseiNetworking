//
//  NSAPIURLSession.swift.swift
//  PasseiNetworking
//
//  Created by Humberto Rodrigues on 06/11/23.
//

import Foundation
import Network

/// Protocolo utilizado para comunicar que a conexão está sendo aguardada pela `NSAPIService`.
protocol NSURLSessionConnectivity {
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
public class NSAPIURLSession: NSObject, URLSessionTaskDelegate, URLSessionDelegate {
    
    /// Delegado para comunicação de conectividade.
    var delegate: NSURLSessionConnectivity
    
    /// Inicializa a classe com o delegado de conectividade.
    init(delegate: NSURLSessionConnectivity) {
        self.delegate = delegate
    }

    /// Sessão URL utilizada para as solicitações da NSAPI.
    lazy var session: URLSession = {
        return URLSession(configuration: delegate.configurationSession, delegate: self, delegateQueue: nil)
    }()
    
    /// Função chamada quando uma tarefa está esperando por conectividade.
    public func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask) {
        delegate.checkWaitingForConnectivity(withURL: task.response?.url) 
        
        // Cancela a tarefa se não estiver em segundo plano
        if delegate.configurationSession == .noBackgroundTask {
            task.cancel()
        }
    }
}


