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
    
    private var isCancelableRequestGetRefreshToken: Bool = false

    /// Sessão para realizar as requisições.
    private var session: URLSession { configuration.apiConnection.session }

    /// Porta para conexão à API (pode ser nula).
    private var port: Int? { configuration.port }

    /// URL base para as requisições à API.
    private var baseURL: String { configuration.baseUrl }

    /// Chave de API para autenticação (pode ser nula).
    private var apiKey: String? { configuration.apiKey }

    /// Interceptor para modificar as requisições.
    internal var interceptor: NSRequestInterceptor?

    /// Autorização para as requisições à API.
    internal var authorization: NSAuthorization?

    /// Configuração global da API.
    internal var configuration: NSAPIConfiguration { NSAPIConfiguration.shared }

    /// Interceptor para modificar a URL base das requisições.
    internal var baseURLInterceptor: NSCustomBaseURLInterceptor?
    
    /// Completa a URL com o caminho fornecido, levando em consideração qualquer interceptor de URL base configurado, porta e URL base.
    /// - Parameter path: O caminho a ser anexado à URL.
    /// - Returns: A string de URL completa.
    private func completeURL(with path: String) -> String {
        
        // Verifica se há um interceptor de URL base configurado
        if let baseURLInterceptor = baseURLInterceptor {
            
            // Se uma porta estiver presente no interceptor, use-a na URL
            guard let port = baseURLInterceptor.port else {
                return "\(baseURLInterceptor.baseURL)/\(path)"
            }
            return "\(baseURLInterceptor.baseURL):\(port)/\(path)"
        }
        
        // Se uma porta estiver presente na configuração, use-a na URL
        if let port = port {
            return "\(baseURL):\(port)/\(path)"
        }
        
        // Use a URL base da configuração e anexe o caminho
        return "\(baseURL)/\(path)"
    }
    
    /// Constrói uma URL com base no caminho fornecido, usando a URL completa após a aplicação do método `completeURL(with:)`.
    /// - Parameter path: O caminho a ser anexado à URL.
    /// - Returns: A URL resultante.
    /// - Throws: Um erro se a URL não puder ser construída.
    private func url(withPath path: String) throws -> URL {
        // Tenta criar uma URL usando a string completa da URL após a aplicação do método `completeURL(with:)`
        guard let url = URL(string: completeURL(with: path)) else {
            throw dispachError("Erro em \(#function): falha ao fazer parse da URL.")
        }
        
        return url
    }
    
    /// Converte uma resposta `URLResponse` para um objeto `HTTPURLResponse`. Lança um erro se a conversão falhar.
    /// - Parameter urlResponse: A resposta da URL a ser convertida.
    /// - Returns: A resposta HTTP convertida.
    /// - Throws: Um erro se a conversão falhar.
    private func response(with urlResponse: URLResponse) throws -> HTTPURLResponse {
        // Tenta realizar a conversão da resposta da URL para um objeto `HTTPURLResponse`
        guard let response = urlResponse as? HTTPURLResponse else {
            throw dispachError("Erro em \(#function): falha na conversão da resposta da URL.")
        }
        return response
    }

    /// Gera um erro `NSAPIError` com uma mensagem e a registra no log.
    /// - Parameter message: A mensagem de erro.
    /// - Returns: Um erro `NSAPIError` contendo a mensagem fornecida.
    private func dispachError(_ message: String) -> NSAPIError {
        LogManager.dispachLog(message)
        return NSAPIError.info(message)
    }

    /// Executa uma solicitação assíncrona para buscar dados do servidor, usando os parâmetros fornecidos.
    /// - Parameters:
    ///   - httpResponse: O tipo de resposta esperado que será usado para decodificar os dados.
    ///   - nsParameters: Os parâmetros da solicitação.
    /// - Returns: O modelo decodificado da resposta do servidor.
    /// - Throws: Um erro se a solicitação ou a decodificação falharem.
    internal func fetch<T: NSModel>(
        witHTTPResponse httpResponse: T.Type,
        andNSParameters nsParameters: NSParameters
    ) async throws -> T {
        // Tenta realizar a solicitação usando os parâmetros fornecidos
        return try await self.send(witHTTPResponse: httpResponse, nsParameters: nsParameters)
    }
    
    /// Envia uma solicitação assíncrona para o servidor e trata a resposta de acordo com o modelo de resposta esperado.
    /// - Parameters:
    ///   - httpResponse: O tipo de resposta esperado que será usado para decodificar os dados.
    ///   - nsParameters: Os parâmetros da solicitação.
    /// - Returns: O modelo decodificado da resposta do servidor.
    /// - Throws: Um erro se a solicitação, a decodificação ou o tratamento da resposta falharem.
    private func send<T: NSModel>(
        witHTTPResponse: T.Type,
        nsParameters: NSParameters
    ) async throws -> T {
        
        // Tenta realizar a solicitação usando os parâmetros fornecidos
        let (data, urlResponse) = try await self.makeRequest(nsParameters: nsParameters)
        
        // Obtém a resposta convertida para `HTTPURLResponse`
        let response = try self.response(with: urlResponse)
        
        // Resposta de sucesso (códigos 2xx)
        if 200..<299 ~= response.statusCode {
            let jsonDecoder = JSONDecoder()
            let result = try jsonDecoder.decode(T.self, from: data)
            return result
        }
        
        // Token de acesso expirado (código 401)
        if response.statusCode == 401 {
            // Verifica se há um provedor de autorização configurado
            guard let authorization = authorization else {
                throw self.dispachError("Erro em \(#function): provedor de autorização não implementado.")
            }
            
            // Verifica se a solicitação de atualização do token pode ser cancelada
            if !isCancelableRequestGetRefreshToken {
                // Realiza a solicitação de atualização do token
                return try await authorization.refreshToken(completion: { [unowned self] (nsModel, nsPrams) async throws in
                    return try await self.refreshToken(
                        witHTTPResponse: nsModel,
                        nsParameters: nsPrams,
                        lastCallReponse: witHTTPResponse,
                        lastNSParameters: nsParameters
                    )
                })
            }
        }
        
        // Erro interno do servidor (código 500)
        if response.statusCode == 500 {
            throw dispachError("Erro no servidor em \(#function), código de status \(response.statusCode)")
        }
        
        // Trata outros erros provenientes da API
        let resultError = try self.throwsApiError(response: response, data: data)
        throw NSAPIError.acknowledgedByAPI(resultError)
    }

    
    /// Cria e envia uma solicitação assíncrona ao servidor usando os parâmetros fornecidos.
    /// - Parameter nsParameters: Os parâmetros da solicitação.
    /// - Returns: Uma tupla contendo os dados da resposta e a resposta do servidor.
    /// - Throws: Um erro se a criação da URL, a configuração da solicitação ou a obtenção dos dados falharem.
    private func makeRequest(nsParameters: NSParameters) async throws -> (Data, URLResponse) {
        
        // Monta o caminho da URL com base nos parâmetros fornecidos
        var path = nsParameters.path.rawValue
        
        if let param = nsParameters.param {
            path = "\(path)/\(param)"
        }
        
        // Cria a URL completa
        let url = try self.url(withPath: path)
        
        // Configura os componentes da URL, incluindo a consulta (query string) se houver
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        if !nsParameters.queryString.isEmpty {
            let queryString = nsParameters.queryString
            urlComponents?.queryItems = queryString.map({ URLQueryItem(name: $0.rawValue, value: "\($1)") })
        }
        
        // Verifica se os componentes da URL são válidos
        guard let urlWithComponents = urlComponents?.url else {
            throw dispachError("Erro em \(#function): falha ao criar a URL")
        }
        
        // Cria a solicitação URLRequest
        var urlRequest = URLRequest(url: urlWithComponents)
        
        // Adiciona a chave da API aos cabeçalhos da solicitação, se disponível
        if let apiKey = apiKey {
            urlRequest.setValue(apiKey, forHTTPHeaderField: "X-API-Key")
        }
        
        // Intercepta a solicitação, se um interceptor estiver configurado
        interceptor?.intercept(with: &urlRequest)
        
        // Configura o método HTTP da solicitação
        urlRequest.httpMethod = nsParameters.method.rawValue
        
        // Configura o corpo da solicitação para métodos diferentes de GET
        if nsParameters.method != .GET {
            if let httpRequest = nsParameters.httpRequest {
                let encoder = JSONEncoder()
                let data = try encoder.encode(httpRequest)
                urlRequest.httpBody = data
            }
        }
        
        // Envia a solicitação e aguarda os dados da resposta
        return try await session.data(for: urlRequest)
    }

    
    /// Renova o token de acesso e realiza novamente a última chamada à API usando os parâmetros fornecidos.
    /// - Parameters:
    ///   - witHTTPResponse: O tipo de resposta esperada para a última chamada à API.
    ///   - nsParameters: Os parâmetros para a última chamada à API.
    ///   - lastCallReponse: O tipo de resposta esperada para a última chamada à API antes do refreshToken.
    ///   - lastNSParameters: Os parâmetros para a última chamada à API antes do refreshToken.
    /// - Returns: O modelo representando a resposta da última chamada à API após a renovação do token.
    /// - Throws: Um erro se a renovação do token falhar ou se a última chamada à API resultar em um erro.
    private func refreshToken<T: NSModel, S: NSModel>(
        witHTTPResponse: T.Type,
        nsParameters: NSParameters,
        lastCallReponse: S.Type,
        lastNSParameters: NSParameters
    ) async throws -> S {
        
        // Indica que a solicitação de refreshToken pode ser cancelada
        isCancelableRequestGetRefreshToken = true
        
        // Faz a solicitação de refreshToken
        let (data, urlResponse) = try await self.makeRequest(nsParameters: lastNSParameters)
        
        // Obtém a resposta do servidor
        let response = try self.response(with: urlResponse)
        
        // Se a resposta for bem-sucedida (código 200 ou 201)
        if (response.statusCode == 200 || response.statusCode == 201) {
            // Salva os dados do novo token de acesso
            self.authorization?.save(withData: data)
            // Realiza novamente a última chamada à API
            return try await self.fetch(witHTTPResponse: lastCallReponse, andNSParameters: lastNSParameters)
        }
        
        // Se o servidor retornar um erro interno (código 500)
        if response.statusCode == 500 {
            throw dispachError("Erro interno do servidor em \(#function), código de status \(response.statusCode)")
        }
        
        // Obtém o erro específico da API, se houver
        let resultError = try self.throwsApiError(response: response, data: data)
        
        // Lança um erro com base no erro específico da API
        throw NSAPIError.acknowledgedByAPI(resultError)
    }

    
    /// Gera um objeto `NSAcknowledgedByAPI` a partir da resposta e dados fornecidos pela API.
    /// - Parameters:
    ///   - response: A resposta HTTP da API.
    ///   - data: Os dados da resposta da API.
    /// - Returns: Um objeto `NSAcknowledgedByAPI` representando o erro retornado pela API.
    /// - Throws: Um erro se a decodificação dos dados falhar.
    private func throwsApiError(response: HTTPURLResponse, data: Data) throws -> NSAcknowledgedByAPI {
        // Imprime o código de status para debug
        debugPrint("STATUS CODE ERROR", response.statusCode)
        // Registra o erro no log
        LogManager.dispachLog("Erro em \(#function), código de status \(response.statusCode)")
        
        // Decodifica os dados da resposta em um objeto NSAcknowledgedByAPI
        let jsonDecoder = JSONDecoder()
        return try jsonDecoder.decode(NSAcknowledgedByAPI.self, from: data)
    }

}
