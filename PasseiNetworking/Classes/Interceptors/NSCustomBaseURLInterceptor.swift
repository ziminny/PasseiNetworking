//
//  File.swift
//  
//
//  Created by Vagner Oliveira on 03/07/23.
//

import Foundation


public protocol NSCustomBaseURLInterceptor {
    
    var baseURL:String { get set }
    var port:Int? { get set }
    
}

public extension NSCustomBaseURLInterceptor {
    
    var port:Int? {nil}
}
