//
//  HTTPHeaderProtocol.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation

protocol HTTPHeaderProtocol {
    
    associatedtype ValueType = Any
    
    static var headerValue:ValueType { get }
    
    static var headerKey:HTTPHeaderConfiguration.Keys { get }
}
