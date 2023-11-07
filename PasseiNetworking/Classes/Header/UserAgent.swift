//
//  UserAgent.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation
import UIKit

struct UserAgent:HTTPHeaderProtocol {

    typealias ValueType = String
    
    static var headerKey: HTTPHeaderConfiguration.Keys { .userAgent }
    static var headerValue: ValueType {
        
        var userAgentString:String = ""

        if let infoPlist = try? PListFile<InfoPlist>(),
           let appName = infoPlist.data.bundleName,
           let version = infoPlist.data.versionNumber,
           let build = infoPlist.data.buildNumber,
           let cfNetworkVersionString = cfNetworkVersion {

          let modelName = UIDevice.current.model
          let platform = UIDevice.current.systemName
          let operationSystemVersion = ProcessInfo.processInfo.operatingSystemVersionString

          userAgentString = "\(appName)/\(version).\(build) " +
          "(\(platform); \(modelName); \(operationSystemVersion)) " +
          "CFNetwork/\(cfNetworkVersionString)"
       }

        return userAgentString
    }
    
    
    static var cfNetworkVersion: String? {
          guard
            let bundle = Bundle(identifier: "com.apple.CFNetwork"),
            let versionAny = bundle.infoDictionary?[kCFBundleVersionKey as String],
            let version = versionAny as? String
            else { return nil }
          return version
    }  
}
