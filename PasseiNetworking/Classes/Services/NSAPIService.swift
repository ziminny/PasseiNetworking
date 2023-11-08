//
//  File.swift
//  
//
//  Created by Vagner Oliveira on 02/06/23.
//

import Foundation
import PasseiLogManager

public protocol NSAPIServiceDelegate {
    var configurationSession:URLSessionConfiguration { get }
    func networkUnavailableAction()
}

/// Essa classe é exposta para o cliente
@available(iOS 13.0.0, *)
public class NSAPIService {
    
    private var nsParameters:NSParameters?
    private var apiRequester:NSAPIRequester =  NSAPIRequester()
    
    /// Ao criar no módulo solicitado um NSAPIService, caso queira verificar a disponibilidade da internet, entregar a responsabilidade desse delegate
    public var delegate: NSAPIServiceDelegate?
    
    public init() {
        NSAPIConfiguration.shared.delegate = self
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
    public func fetchAsync<T:NSModel>(_ httpResponse:T.Type, nsParameters:NSParameters) async throws -> T? {
        return try await apiRequester.fetch(
                witHTTPResponse:httpResponse,
                andNSParameters:nsParameters
            )
    }
    
    @discardableResult
    public func setNSParamns(withParameters nsParameters:NSParameters) -> Self {
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
    public func fetch<T:NSModel>(_ httpResponse:T.Type,closure: @escaping (Result<T,Error>) -> Void ) -> Task<Void, Error> {
        
          Task {
        
            do {
                
                guard let nsParameters = nsParameters else {
                    throw NSAPIError.unknowError()
                }
                
                let response = try await apiRequester.fetch(
                        witHTTPResponse:httpResponse,
                        andNSParameters:nsParameters
                    )
                closure(.success(response))
            } catch {
                LogManager.dispachLog("error: \(#function) \(error.localizedDescription)")
                closure(.failure(error))
            }
          
        }
    }
}

extension NSAPIService: NSAPIConfigurationSessionDelegate {
    var configurationSession: URLSessionConfiguration {
        delegate?.configurationSession ?? .noBackgroundTask
    }
    
    func checkWaitingForConnectivity() {
        delegate?.networkUnavailableAction()
    }
}




