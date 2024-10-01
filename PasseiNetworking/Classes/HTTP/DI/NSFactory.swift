//
//  NSFactory.swift
//  AppAuth
//
//  Created by vagner reis on 01/10/24.
//

import Foundation

@propertyWrapper
public struct NSFactory<Service: NSServiceProtocol> {
    
    private var service: Service?
    private var instanceType: NSInstanceType
    
    public init(instanceType: NSInstanceType = .Singleton) {
        self.instanceType = instanceType
    }
    
    public var wrappedValue: Service {
        
        mutating get {
            
            if instanceType == .NewInstance {
                service = Service(withFactory: Factory.instance)
                return service!
            }
            
            let retainInstance = RetainInstance<Service>()
            let contain = retainInstance(contains: Service.self)
          
            if contain == nil {
                let inserted = retainInstance(append: Service.self)
                service = inserted
            } else {
                service = contain
            }
            
            return service!
            
        } set {
            service = newValue
        }
        
    }
    
}

@dynamicCallable
fileprivate struct RetainInstance<Service: NSServiceProtocol> {
        
    func dynamicallyCall(withKeywordArguments args: KeyValuePairs<String, Service.Type>) -> Service? {
        
        for (key,_) in args {
            if key == "contains" {
                return StorageInstence.shared.get(ofType: Service.self)
            }
            if key == "append" {
                let service = Service(withFactory: Factory.instance)
                StorageInstence.shared.append(service)
                return service
            }
        }
        
        return nil
    }
    
}

fileprivate final class StorageInstence: Sendable {
    
    static nonisolated(unsafe) var shared = StorageInstence()
    
    static nonisolated(unsafe) private(set) var instances: [any NSServiceProtocol] = []
    
    private let privateQueue: DispatchQueue = DispatchQueue(label: "com.passiOAB.NSFactory", attributes: .concurrent)
    
    func append(_ item: any NSServiceProtocol) {
        privateQueue.async(flags: .barrier) {
            StorageInstence.instances.append(item)
        }
    }
    
    func get<Service: NSServiceProtocol>(ofType: Service.Type) -> Service? {
        return privateQueue.sync {
            return StorageInstence.instances.first { $0 is Service } as? Service
        }
    }
}

fileprivate struct Factory: Sendable {
    nonisolated(unsafe) static var instance = NSHTTPServiceFactory()
}
