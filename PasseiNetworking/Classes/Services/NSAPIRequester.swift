//
//  File.swift
//  
//
//  Created by Vagner Oliveira on 03/06/23.
//

import Foundation
import PasseiLogManager

/// Responsável por fazer as requisições na API
@available(iOS 13.0.0, *)
class NSAPIRequester {
    
    var interceptor:NSRequestInterceptor?
    
    var authorization:NSAuthorization?
    
    private var isCancelableRequestGetRefreshToken:Bool = false;
    
    private var session:URLSession {
        NSAPIConfiguration.shared.apiConnection.session
    }
    
    private let port:Int = NSAPIConfiguration.shared.port
    private let baseURL:String = NSAPIConfiguration.shared.baseUrl
    
    var baseURLInterceptor:NSCustomBaseURLInterceptor?
    
    private func completeURL(withpath path:String) -> String {
        
        if let baseURLInterceptor {
            guard let port = baseURLInterceptor.port else {
                return "\(baseURLInterceptor.baseURL)/\(path)"
            }
            return "\(baseURLInterceptor.baseURL):\(port)/\(path)"
        }
        
        return "\(String(describing: self.baseURL)):\(self.port)/\(path)"
    }
    
    private func url(withPath path:String) throws -> URL {
        guard let url = URL(string: self.completeURL(withpath: path)) else {
            throw dispachError("error \(#function) url parser")
        }
        
        return url
    }
    
    private func response(with urlResponse:URLResponse) throws -> HTTPURLResponse {
        guard let response = urlResponse as? HTTPURLResponse else {
            throw dispachError("error \(#function) urlResponse convert")
        }
        return response
    }
    
    private func dispachError(_ message:String) -> NSAPIError {
        LogManager.dispachLog(message)
        return NSAPIError.info(message)
    }
    
    
      func fetch<T:NSModel>(witHTTPResponse httpResponse:T.Type, andNSParameters nsParameters:NSParameters) async throws -> T {
        
        switch nsParameters.method {
        case .GET:
            return try await self.get(witHTTPResponse:httpResponse,nsParameters: nsParameters)
        default:
            // POST, PUT or DELETE
            return try await self.post(witHTTPResponse:httpResponse,nsParameters: nsParameters)
        }
    }
    
     func get<T:NSModel>(witHTTPResponse:T.Type,nsParameters:NSParameters) async throws -> T {
 
        let path = nsParameters.path.rawValue
         let url = try self.url(withPath: path)
        
   
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        if !nsParameters.queryString.isEmpty {
            let queryString = nsParameters.queryString
            urlComponents?.queryItems = queryString.map({ URLQueryItem(name: $0, value: "\($1)") })
        }
        
        guard let urlWithComponents = urlComponents?.url else {
            throw dispachError("error \(#function) url parser")
        }
        
        
        var urlRequest = URLRequest(url: urlWithComponents)
        
        interceptor?.intercept(with: &urlRequest)
        
        urlRequest.httpMethod = nsParameters.method.rawValue
        
        
        let (data,urlResponse) = try await session.data(for: urlRequest);
        
        let response = try self.response(with: urlResponse)
        
        if 200..<299 ~= response.statusCode {
            let jsonDecoder = JSONDecoder()
            let result = try jsonDecoder.decode(T.self, from: data)
            return result
        }
        
        // Expired token
        if response.statusCode == 401 {
            
            guard let authorization else {
                throw self.dispachError("error function \(#function) file implemented authorization provider")
            }
            
            if !isCancelableRequestGetRefreshToken {
                return try await authorization.refreshToken(completion:{ [unowned self] (nsModel, nsPrams) async throws in
                         return try await self.refreshToken(witHTTPResponse: nsModel, nsParameters: nsPrams, lastCallReponse: witHTTPResponse, lastNSParameters: nsParameters)
                 })
            }
            
        }
        
        if response.statusCode == 500 {
            throw dispachError("server error \(#function) status code \(response.statusCode)")
        }
        
         LogManager.dispachLog("error \(#function) status code \(response.statusCode)")
         let jsonDecoder = JSONDecoder()
         let resultError = try jsonDecoder.decode(NSAcknowledgedByAPI.self, from: data)
         throw NSAPIError.acknowledgedByAPI(resultError)
    }
    
    
     func post<T:NSModel>(witHTTPResponse:T.Type,nsParameters:NSParameters) async throws -> T {
       
        let path = nsParameters.path.rawValue
 
        let url = try self.url(withPath: path)
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
         
     
        
        if !nsParameters.queryString.isEmpty {
            let queryString = nsParameters.queryString
            urlComponents?.queryItems = queryString.map({ URLQueryItem(name: $0, value: "\($1)") })
        }
        
        guard let urlWithComponents = urlComponents?.url else {
            print("ERRO AQUI")
            throw dispachError("error \(#function) url parser")
     
        }
        
        
        var urlRequest = URLRequest(url: urlWithComponents)
        
        interceptor?.intercept(with: &urlRequest)
        
        urlRequest.httpMethod = nsParameters.method.rawValue
        
        
        if let httpRequest = nsParameters.httpRequest {
            let encoder = JSONEncoder()
            let data = try encoder.encode(httpRequest)
            urlRequest.httpBody = data
        }
        
        let (data,urlResponse) = try await session.data(for: urlRequest);
        
        let response = try self.response(with: urlResponse)
        
        // Success response
        if 200..<299 ~= response.statusCode {
            let jsonDecoder = JSONDecoder()
            
            let result = try jsonDecoder.decode(T.self, from: data)
            return result
        }
        
         // Expired token
         if response.statusCode == 401 {
             
             guard let authorization else {
                 throw self.dispachError("error function \(#function) file not implemented authorization provider")
             }
             if !isCancelableRequestGetRefreshToken {
                 return try await authorization.refreshToken(completion:{ [unowned self] (nsModel, nsPrams) async throws in
                          return try await self.refreshToken(witHTTPResponse: nsModel, nsParameters: nsPrams, lastCallReponse: witHTTPResponse, lastNSParameters: nsParameters)
                  })
             }
         }
        
        if response.statusCode == 500 {
            throw dispachError("server error \(#function) status code \(response.statusCode)")
        }
         
         LogManager.dispachLog("error \(#function) status code \(response.statusCode)")
         let jsonDecoder = JSONDecoder()
         let resultError = try jsonDecoder.decode(NSAcknowledgedByAPI.self, from: data)
         throw NSAPIError.acknowledgedByAPI(resultError)
    }
    
    func refreshToken<T:NSModel,S:NSModel>(witHTTPResponse:T.Type,nsParameters:NSParameters,lastCallReponse:S.Type,lastNSParameters:NSParameters) async throws  -> S {
 
        isCancelableRequestGetRefreshToken = true
        
        let path = nsParameters.path.rawValue
 
        let url = try self.url(withPath: path)
        
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        if !nsParameters.queryString.isEmpty {
            let queryString = nsParameters.queryString
            urlComponents?.queryItems = queryString.map({ URLQueryItem(name: $0, value: "\($1)") })
        }
        
        guard let urlWithComponents = urlComponents?.url else {
            throw dispachError("error \(#function) url parser")
     
        }
        
        
        var urlRequest = URLRequest(url: urlWithComponents)
        
        interceptor?.intercept(with: &urlRequest)
        
        urlRequest.httpMethod = nsParameters.method.rawValue
        
        
        if let httpRequest = nsParameters.httpRequest {
            let encoder = JSONEncoder()
            let data = try encoder.encode(httpRequest)
            urlRequest.httpBody = data
        }
        
        
        let (data,urlResponse) = try await session.data(for: urlRequest);
        
        let response = try self.response(with: urlResponse)
        
        if (response.statusCode == 200 || response.statusCode == 201) {
            self.authorization?.save(withData: data)
            return try await self.fetch(witHTTPResponse: lastCallReponse, andNSParameters: lastNSParameters)
        }
        
        if response.statusCode == 500 {
            throw dispachError("server error \(#function) status code \(response.statusCode)")
        }
       
        debugPrint("STATUS CODE REFRESH TOKEN ERROR",response.statusCode)
        LogManager.dispachLog("error \(#function) status code \(response.statusCode)")
        let jsonDecoder = JSONDecoder()
        let resultError = try jsonDecoder.decode(NSAcknowledgedByAPI.self, from: data)
        throw NSAPIError.acknowledgedByAPI(resultError)
        
    }
    
   
}
