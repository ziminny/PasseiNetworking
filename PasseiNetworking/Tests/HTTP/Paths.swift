//
//  Paths.swift
//  PasseiNetworking-Unit-Tests
//
//  Created by vagner reis on 13/10/24.
//

import Foundation
@testable import PasseiNetworking

enum Paths: NSRawValue {
    
    case test
    case testQueryString
    case testParam
    
    init?(rawValue: String?) {
        guard let rawValue else {
            return nil
        }
        
        switch rawValue {
        case "test":
            self = .test
        case "test_query_string":
            self = .testQueryString
        case "test_param":
            self = .testParam
        default:
            return nil
        }
    }
    
    var rawValue: String {
        switch self {
        case .test:
            return "test"
        case .testQueryString:
            return "test_query_string"
        case .testParam:
            return "test_param"
        }
    }
    
}
