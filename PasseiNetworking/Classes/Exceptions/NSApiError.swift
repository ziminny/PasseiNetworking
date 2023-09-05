//
//  NSAPIError.swift
//
//  Created by Vagner Oliveira on 06/06/23.
//

import Foundation

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
}

