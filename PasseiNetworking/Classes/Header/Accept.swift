//
//  Accept.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation

class Accept:HTTPHeaderProtocol {

    typealias ValueType = String
    
    static var headerKey: HTTPHeaderConfiguration.Keys { .accept }
    static var headerValue: ValueType { "application/json" }
}
