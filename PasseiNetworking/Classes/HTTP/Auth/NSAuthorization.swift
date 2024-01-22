//
//  NSAuthorization.swift
//  
//
//  Created by Vagner Oliveira on 06/06/23.
//

import Foundation

/// Atutorização da API
@available(iOS 13.0.0, *)
public protocol NSAuthorization {
    
    /// Busca pelo refresh token e injeta da requisição
    ///  - NSModel.Type: Classe de retorno
    ///  - NSParameters: Parâmetros da requisição
    func refreshToken<T:NSModel>(completion: @escaping (NSModel.Type,NSParameters) async throws -> NSModel) async throws -> T
    
    func save(withData data:Data)
}
