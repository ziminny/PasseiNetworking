//
//  NSHTTPMethod.swift
//
//  Created by Vagner Oliveira on 03/06/23.
//

import Foundation

/// Verbos http
/// Esse enum trás todos os metodos https
public enum NSHTTPMethod: String, Sendable {
    case POST = "POST"
    case PUT = "PUT"
    case GET = "GET"
    case DELETE = "DELETE"
}
