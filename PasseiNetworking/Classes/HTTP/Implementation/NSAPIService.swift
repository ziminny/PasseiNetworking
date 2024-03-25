//
//  File.swift
//
//
//  Created by Vagner Oliveira on 02/06/23.
//

import Foundation
import PasseiLogManager
import Network
import Combine

/// Um protocolo que define as propriedades e métodos necessários para a configuração e manipulação de serviços de API.
public protocol NSAPIServiceDelegate: AnyObject {
    
    /// A configuração de sessão URLSession a ser usada para os serviços de API.
    var configurationSession: URLSessionConfiguration { get }
    
    /// Executa uma ação específica quando a rede não está disponível.
    /// - Parameter url: A URL associada à ação, caso seja relevante.
    func networkUnavailableAction(withURL url: URL?)
}

/// Essa classe é exposta para o cliente
@available(iOS 13.0.0, *)
public class NSAPIService {
    
    /// Os parâmetros de uma solicitação de API.
    private var nsParameters: NSParameters?

    /// O objeto responsável por realizar as solicitações de API.
    private var apiRequester: NSAPIRequester = NSAPIRequester()
    
    /// Ao criar no módulo solicitado um NSAPIService, caso queira verificar a disponibilidade da internet, entregar a responsabilidade desse delegate
    public weak var delegate: NSAPIServiceDelegate?
    
    public init() { 
        apiRequester.delegate = self
    }
    
    @discardableResult
    public func interceptor(_ interceptor:NSRequestInterceptor) -> Self {
        apiRequester.interceptor = interceptor
        return self
    }
    
    @discardableResult
    public func authorization(_ authorization:NSAuthorization) -> Self {
        apiRequester.authorization = authorization
        return self
    }
    
    @discardableResult
    public func customURL(_ nsCustomBaseURLInterceptor:NSCustomBaseURLInterceptor) -> Self {
        apiRequester.baseURLInterceptor = nsCustomBaseURLInterceptor
        return self
    }
    
    /// Requisição de forma assincrona
    /// - Exemplo:
    ///     ```
    ///     func auth(request:OABAuthRequestModel) async throws  -> OABAuthResponseModel? {
    ///
    ///          let apiService = NSAPIService()
    ///
    ///          let nsParameters = NSParameters(
    ///          method: .POST,
    ///          httpRequest: request,
    ///          path: .passeiOAB(.auth)
    ///         )
    ///
    ///         let response = try await apiService.fetchAsync(OABAuthResponseModel.self, nsParameters: nsParameters)
    ///
    ///         return response
    ///
    ///     }
    ///     ```
    public func fetchAsync<T: NSModel>(_ httpResponse:T.Type, nsParameters:NSParameters) async throws -> T? {
        
        try self.breakRequestIfNotBakgroundTask()
        
        return try await apiRequester.fetch(
                witHTTPResponse: httpResponse,
                andNSParameters: nsParameters
            )
    }
    
    public func publisher<T: NSModel>(_ httpResponse: T.Type, nsParameters: NSParameters) -> Future<T?,Error> {
        
        return Future<T?,Error> { promise in
            Task {
                do {
                    
                    try self.breakRequestIfNotBakgroundTask()
                    
                    let model = try await self.apiRequester.fetch(
                        witHTTPResponse: httpResponse,
                        andNSParameters: nsParameters
                    )
                    
                    promise(.success(model))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    public func setNSParamns(withParameters nsParameters: NSParameters) -> Self {
        self.nsParameters = nsParameters
        return self
    }
    

    /// Requisição com closure
    /// - Exemplo:
    ///     ```
    ///       func auth() {
    ///           // ...
    ///           // nsParameters
    ///           // ...
    ///           let apiService = NSAPIService()
    ///           apiService.fetch(MyModel.self) { result in
    ///               switch result {
    ///               case .success(let myModel):
    ///                   break;
    ///               case .failure(let error):
    ///                   break;
    ///               }
    ///          }
    ///      }
    ///     ```
    @discardableResult
    public func fetch<T: NSModel>(_ httpResponse: T.Type,closure: @escaping (Result<T,Error>) -> Void ) -> Task<Void, Error> {
        
          Task {
        
            do {
                
                try self.breakRequestIfNotBakgroundTask()
                
                guard let nsParameters = nsParameters else {
                    throw NSAPIError.unknownError()
                }
                
                let response = try await apiRequester.fetch(
                        witHTTPResponse: httpResponse,
                        andNSParameters: nsParameters
                    )
                closure(.success(response))
            } catch {
                LogManager.dispachLog("error: \(#function) \(error.localizedDescription)")
                closure(.failure(error))
            }
          
        }
    }
    
    private func breakRequestIfNotBakgroundTask() throws{
        if delegate?.configurationSession == nil || delegate?.configurationSession == .noBackgroundTask {
            let service = NSNetworkStatus(queue: .global())
            if !service.isConnected {
                throw NSAPIError.noInternetConnection
            }
 
        }
    }
    
}

extension NSAPIService: NSAPIConfigurationSessionDelegate {
    func checkWaitingForConnectivity(withURL url: URL?) {
        delegate?.networkUnavailableAction(withURL: url)
    }
    
    var configurationSession: URLSessionConfiguration {
        delegate?.configurationSession ?? .noBackgroundTask
    }
}

 






