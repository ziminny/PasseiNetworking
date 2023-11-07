//
//  PlistFile.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation

public class PListFile<Value:Codable> {
    
    /// - fileNotFound: plist file not exists
    public enum PlistError:Error {
        case fileNotFound
    }
    
    public enum Source {
        
        case infoPlist(_:Bundle)
        
        internal func data() throws -> Data {
            switch self {
            case .infoPlist(let bundle):
                guard let infoDict = bundle.infoDictionary else {
                    throw PlistError.fileNotFound
                }
                return try JSONSerialization.data(withJSONObject: infoDict)
            }
        }
    }
    
    public let data:Value
    
    public init(_ file:PListFile.Source = .infoPlist(Bundle.main)) throws {
        let rawData = try file.data()
        let decoder = JSONDecoder()
        self.data = try decoder.decode(Value.self, from: rawData)
    }
    
}
