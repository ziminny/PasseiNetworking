//
//  Lang.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 06/11/23.
//

import Foundation

struct Lang:HTTPHeaderProtocol {
    
    typealias ValueType = String
    
    static var headerValue: ValueType {
        return Locale.current.identifier
    }
    
    static var headerKey: HTTPHeaderConfiguration.Keys { .lang }
    
    
}
