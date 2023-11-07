//
//  HTTPHeader.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation
import UIKit

struct HTTPHeader:Decodable {
    
    static var headerDict:[String:Any] = {
        
        var header:[String:Any] = [:]
        header[UserAgent.headerKey.rawValue] = UserAgent.headerValue
        header[ContentType.headerKey.rawValue] = ContentType.headerValue
        header[Accept.headerKey.rawValue] = Accept.headerValue
        header[Lang.headerKey.rawValue] = Lang.headerValue

        return header
        
    }()

}
