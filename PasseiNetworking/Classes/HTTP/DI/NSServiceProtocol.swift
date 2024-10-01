//
//  NSServiceProtocol.swift
//  AppAuth
//
//  Created by vagner reis on 01/10/24.
//

import Foundation

public protocol NSServiceProtocol where Self: Sendable {
    var factory: NSHTTPServiceFactory { get }
    init(withFactory factory: NSHTTPServiceFactory)
}
