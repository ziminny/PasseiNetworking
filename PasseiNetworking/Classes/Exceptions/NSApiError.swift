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
    public private(set) var statusCode:Int
    public private(set) var message:String
}

/// Tipos de erros da aplicação
public enum NSAPIError:Error {
    case unknowError(String? = nil)
    case info(String)
    case acknowledgedByAPI(NSAcknowledgedByAPI)
    case noInternetConnection
}

public extension NSAPIError {
    static func outherError(withError error:Error,callback: @escaping (NSAPIError) -> Void) {
        if let error = error as NSError? {
            if error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled {
                LogManager.dispachLog("Erro de comunicação com a api \(Self.self) \(#function)")
                callback(NSAPIError.noInternetConnection)
                return
            }
            LogManager.dispachLog("Erro desconhecido, tente novamente mais tarte \(Self.self) \(#function)")
            callback(.unknowError(error.localizedDescription))
        }
    }
}

