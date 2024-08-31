//
//  NSAPIError.swift
//
//  Created by Vagner Oliveira on 06/06/23.
//

import Foundation
import PasseiLogManager

/// Erro de retorno do backend
///  - Atributos
///    - statusCode: Código de erro da requisição
///    - message: A mensagem do erro
public struct NSAcknowledgedByAPI:Codable {
    public private(set) var statusCode: Int
    public private(set) var message: String
}

/// Enumeração que representa os possíveis erros relacionados à API.
public enum NSAPIError: LocalizedError {
    /// Erro desconhecido.
    case unknownError(String? = nil)
    
    /// Informação sobre o erro.
    case info(String)
    
    /// Resposta confirmada pela API.
    case acknowledgedByAPI(NSAcknowledgedByAPI)
    
    /// Sem conexão com a Internet.
    case noInternetConnection
    
    public var errorDescription: String? {
        switch self {
        case .unknownError(let message):
            return message
        case .info(let message):
            return message
        case .noInternetConnection:
            return NSTranslate.shared.message(.noInternetConnection)
        case .acknowledgedByAPI(let acknowledgedByAPI):
            return acknowledgedByAPI.message
        }
    }
    
}

public extension NSAPIError {
    /// Método para lidar com outros erros não especificados na enumeração.
    ///
    /// - Parameters:
    ///   - error: O erro a ser tratado.
    ///   - callback: Um bloco de conclusão chamado após o tratamento do erro.
    static func otherError(withError error: Error) -> NSAPIError {
        if let error = error as NSError? {
            if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
                LogManager.dispachLog("Erro de comunicação com a API \(Self.self) \(#function)")
                return .noInternetConnection
            }
            LogManager.dispachLog("Erro desconhecido, tente novamente mais tarde \(Self.self) \(#function)")
            return .unknownError(error.localizedDescription)
        }
    }
}


