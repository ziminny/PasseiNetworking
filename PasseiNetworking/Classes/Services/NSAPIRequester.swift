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
final internal class NSAPIRequester {
    
    private  var isCancelableRequestGetRefreshToken: Bool = false;
    
    private  var session: URLSession { configuration.apiConnection.session }
    
    private  var port: Int? { configuration.port }
    
    private  var baseURL: String { configuration.baseUrl }
    
    private  var apiKey: String? { configuration.apiKey }
    
    internal var interceptor: NSRequestInterceptor?
    
    internal var authorization: NSAuthorization?
    
    internal var configuration: NSAPIConfiguration { NSAPIConfiguration.shared }
    
    internal var baseURLInterceptor: NSCustomBaseURLInterceptor?
    
    private func completeURL(withpath path: String) -> String {
        
        if let baseURLInterceptor {
            guard let port = baseURLInterceptor.port else {
                return "\(baseURLInterceptor.baseURL)/\(path)"
            }
            return "\(baseURLInterceptor.baseURL):\(port)/\(path)"
        }
        
        if let port = self.port {
            return "\(String(describing: self.baseURL)):\(port)/\(path)"
        }
        
        return "\(String(describing: self.baseURL))/\(path)"
    }
    
    private func url(withPath path: String) throws -> URL {
        guard let url = URL(string: self.completeURL(withpath: path)) else {
            throw dispachError("error \(#function) url parser")
        }
        
        return url
    }
    
    private func response(with urlResponse: URLResponse) throws -> HTTPURLResponse {
        guard let response = urlResponse as? HTTPURLResponse else {
            throw dispachError("error \(#function) urlResponse convert")
        }
        return response
    }
    
    private func dispachError(_ message: String) -> NSAPIError {
        LogManager.dispachLog(message)
        return NSAPIError.info(message)
    }
    
    internal func fetch<T: NSModel>(
        witHTTPResponse httpResponse: T.Type,
        andNSParameters nsParameters: NSParameters
    ) async throws -> T {
        
        return try await self.send(witHTTPResponse:httpResponse,nsParameters: nsParameters)
        
    }
    
    private func send<T: NSModel>(
        witHTTPResponse:T.Type,
        nsParameters: NSParameters
    ) async throws -> T {

        let (data,urlResponse) = try await self.makeRequest(nsParameters: nsParameters);
        
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
        
        let resultError = try self.throwsApiError(response: response, data: data)
        throw NSAPIError.acknowledgedByAPI(resultError)
        
    }
    
    private func makeRequest(nsParameters: NSParameters) async throws -> (Data, URLResponse) {
        
        var path = nsParameters.path.rawValue
        
        if let param = nsParameters.param {
            path = "\(path)/\(param)"
        }
        
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
        
        if let apiKey {
            urlRequest.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        }
        
        interceptor?.intercept(with: &urlRequest)
        
        urlRequest.httpMethod = nsParameters.method.rawValue
        
        if nsParameters.method != .GET {
            if let httpRequest = nsParameters.httpRequest {
                let encoder = JSONEncoder()
                let data = try encoder.encode(httpRequest)
                urlRequest.httpBody = data
            }
        }
        
        return try await session.data(for: urlRequest);
    }
    
    private func refreshToken<T: NSModel,S: NSModel>(
        witHTTPResponse: T.Type,
        nsParameters: NSParameters,
        lastCallReponse: S.Type,
        lastNSParameters: NSParameters
    ) async throws  -> S {
        
        isCancelableRequestGetRefreshToken = true
        
        let (data,urlResponse) = try await self.makeRequest(nsParameters: lastNSParameters);
        
        let response = try self.response(with: urlResponse)
        
        if (response.statusCode == 200 || response.statusCode == 201) {
            self.authorization?.save(withData: data)
            return try await self.fetch(witHTTPResponse: lastCallReponse, andNSParameters: lastNSParameters)
        }
        
        if response.statusCode == 500 {
            throw dispachError("server error \(#function) status code \(response.statusCode)")
        }

        let resultError = try self.throwsApiError(response: response, data: data)
        throw NSAPIError.acknowledgedByAPI(resultError)
        
    }
    
    private func throwsApiError(response: HTTPURLResponse, data:Data) throws -> NSAcknowledgedByAPI {
        debugPrint("STATUS CODE REFRESH TOKEN ERROR",response.statusCode)
        LogManager.dispachLog("error \(#function) status code \(response.statusCode)")
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(NSAcknowledgedByAPI.self, from: data)
    }
}
