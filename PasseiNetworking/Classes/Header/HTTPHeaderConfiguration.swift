//
//  HTTPHeaderKey.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 06/11/23.
//

import Foundation

struct HTTPHeaderConfiguration {
    enum Keys:String {
        case accept = "accept"
        case contentType = "content-type"
        case userAgent = "user-agent"
        case lang = "lang"
    }
}
