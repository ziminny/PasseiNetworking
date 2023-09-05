//
//  NSInterceptor.swift
//
//  Created by Vagner Oliveira on 06/06/23.
//

import Foundation

// Essa classe intercepta a requisição
public protocol NSRequestInterceptor {
    
    /// Intercepta o request
    ///  - Parâmetros
    ///     - urlRequest: a referência do URLRequest
    ///  - Exemplo:
    ///     ```
    ///        intercept(with:&urlRequest)
    ///     ```
    func intercept( with urlRequest: inout URLRequest)
}

 
