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
public protocol NSModel where Self: Decodable & Encodable {
    var updatedAt:Date { get set }
//    var createdAt:Date { get set }
}
 
public extension NSModel {
    var updatedAt:Date { get { Date() } set {} }
//    var createdAt:Date { get { Date() } set {} }
    
//    TO DO: Pensar numa melhor maneira de passar o createdAt do swift para o backEnd para fins de relatórios, filtros (exemplo: puxar algo por data de criação).
}

