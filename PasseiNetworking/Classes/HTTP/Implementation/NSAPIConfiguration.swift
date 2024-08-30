//
//  File.swift
//  
//
//  Created by Vagner Oliveira on 03/06/23.
//

import Foundation

/// Protocolo que define os requisitos para o delegado de sessão de configuração da API.
protocol NSAPIConfigurationSessionDelegate: AnyObject {
    /// Configuração da sessão de URL que será utilizada pela API.
    var configurationSession: URLSessionConfiguration { get }
    
    /// Método para verificar a espera pela conectividade antes de realizar uma solicitação.
    ///
    /// - Parameter url: A URL para a qual a conectividade será verificada.
    func checkWaitingForConnectivity(withURL url: URL?)
}

/// Classe que representa a configuração inicial da API.
public final class NSAPIConfiguration {
    
    /// Instância compartilhada da configuração da API.
    public static var shared: NSAPIConfiguration = NSAPIConfiguration()
    
    /// Chave de API utilizada nas requisições (opcional).
    public var apiKey: String? = nil
    
    /// Delegado para a configuração da sessão de URL da API.
   // internal var delegate: NSAPIConfigurationSessionDelegate?
    
    /// Configuração da sessão de URL utilizada pela API.
   // internal var configurationSession: URLSessionConfiguration { delegate?.configurationSession ?? .noBackgroundTask }
    
    /// URL base da API.
    private(set) var baseUrl = ""
    
    /// Porta utilizada nas requisições (opcional).
    private(set) var port: Int? = nil
    
    private(set) var language: NSLanguage = .enUS
    
    /// Instância de conexão com a API através da sessão de URL configurada.
    //internal var apiConnection: NSAPIURLSession {
     //   return NSAPIURLSession(delegate: self)
   // }
    
    /// Método para configurar a aplicação com a URL base, porta e chave de API.
    ///
    /// - Parameters:
    ///   - baseURL: A URL base da API.
    ///   - port: A porta utilizada nas requisições (opcional).
    ///   - apiKey: A chave de API utilizada nas requisições (opcional).
    public func application(
        _ baseURL: String,
        _ port: Int? = nil,
        _ apiKey: String? = nil,
        _ language: NSLanguage = .enUS) {
            
        self.baseUrl = baseURL
        self.port = port
        self.apiKey = apiKey
        self.language = language
            
    }
    
    /// Método de inicialização privado.
    // private init() { }
    
}

/// Extensão que implementa o protocolo `NSURLSessionConnectivity` para a configuração da API.
//extension NSAPIConfiguration {
    /// Método para verificar a espera pela conectividade antes de realizar uma solicitação.
    ///
    /// - Parameter url: A URL para a qual a conectividade será verificada.
   // func checkWaitingForConnectivity(withURL url: URL?) {
        //delegate?.checkWaitingForConnectivity(withURL: url)
   // }
//}



 
