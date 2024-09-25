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
public typealias NSModel = Codable & NSSecureCoding & NSObject & Sendable
#else
public protocol NSModel: CustomStringConvertible where Self: Decodable & Encodable & Sendable { }

public extension NSModel {
    var description: String {
        
        var result: Array<String> = []
        
        let mirror = Mirror(reflecting: self)
        
        for children in mirror.children where children.label != nil {
            result.append("Label: \(children.label!) Value: \(children.value) Type: \(type(of: children.value))")
        }
        
        return String(describing: result)
    }
}

#endif
