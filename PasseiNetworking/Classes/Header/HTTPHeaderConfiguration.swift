//
//  HTTPHeaderKey.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 06/11/23.
//

import Foundation

struct HTTPHeaderConfiguration {
    enum Keys:String {
        case accept = "Accept"
        case contentType = "Content-Type"
        case userAgent = "User-Agent"
        case lang = "Lang"
    }
}
