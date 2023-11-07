//
//  ContentType.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation

struct ContentType:HTTPHeaderProtocol {
    
    typealias ValueType = String
    
    static var headerKey: HTTPHeaderConfiguration.Keys { .contentType }
    static var headerValue: ValueType { "application/json" }
}
