//
//  NSModel.swift
//
//  Created by Vagner Oliveira on 03/06/23.
//

import Foundation

/// Toda a model precisa imprementar essa classe
///  - Exemplo
///     ```
///            class MyModel:NSModel {
///            }
///      ```
#if os(macOS)
// Aqui ate poderia ser um typealias, mas futuramente podemos adicionar mais coisas aqui
public typealias NSModel = Codable & NSSecureCoding & NSObject  
#else
    public protocol NSModel where Self: Decodable & Encodable { }
#endif
