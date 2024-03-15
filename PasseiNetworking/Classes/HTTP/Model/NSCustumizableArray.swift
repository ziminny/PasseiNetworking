//
//  NSCustumizableArray.swift
//  PasseiCRM
//
//  Created by Vagner Oliveira on 20/01/24.
//

import Foundation

open class NSCustumizableArray<T: NSModel>: NSObject, NSModel where T: NSObject  {
    
    public static var supportsSecureCoding: Bool { true }
    
    public let elements: [T]
    
    public init(elements: [T]) {
        self.elements = elements
    }
    
    // MARK: - NSSecureCoding
    
    public required init?(coder: NSCoder) {
        guard let decodedArray = coder.decodeObject(of: [NSArray.self, T.self], forKey: "elements") as? [T] else {
            return nil
        }
        self.elements = decodedArray
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(elements, forKey: "elements")
    }
    
    static func make(fromArray array: [T]) -> NSCustumizableArray<T> {
        return NSCustumizableArray(elements: array)
    }
}

