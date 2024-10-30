//
//  NSMTLSKeychainConfiguration.swift
//  PasseiNetworking
//
//  Created by vagner reis on 25/10/24.
//

import Foundation
import PasseiSecurity

public struct NSMTLSKeychainConfiguration {
    
    private var keychain: PSKeychainCertificateHandler
    
    public init() {
        keychain = PSKeychainCertificateHandler()
    }
    
    public mutating func setProperties(keychainLabel: String) {
        PSKeychainProperties.shared.keychainLabel = keychainLabel
    }
    
    public mutating func setProperties(keychainLabel: String, p12CertificateURL: URL?) {
        PSKeychainProperties.shared.keychainLabel = keychainLabel
        PSKeychainProperties.shared.p12CertificateURL = p12CertificateURL
    }
    
    public mutating func setProperties(p12CertificateURL: URL?) {
        PSKeychainProperties.shared.p12CertificateURL = p12CertificateURL
    }
    
    public mutating func setProperties(keychainLabel: String, p12CertificateURL: URL?, p12Password: String) {
        PSKeychainProperties.shared.keychainLabel = keychainLabel
        PSKeychainProperties.shared.p12CertificateURL = p12CertificateURL
        PSKeychainProperties.shared.p12Password = p12Password
    }
    
    public mutating func setProperties(keychainLabel: String, p12Password: String) {
        PSKeychainProperties.shared.keychainLabel = keychainLabel
        PSKeychainProperties.shared.p12Password = p12Password
    }
    
    public func saveIdentityToKeychain() throws {
        try keychain.saveIdentityToKeychain()
    }
    
    public func renewCertificate() throws {
        try keychain.renewCertificate()
    }
    
    public func removeIdentityFromKeychain() -> Bool {
        keychain.removeIdentityFromKeychain()
    }
    
    public func loadClientIdentity() throws -> CFTypeRef? {
        try keychain.loadClientIdentity()
    }
    
    public func identityExistsInKeychain() -> Bool {
        keychain.identityExistsInKeychain()
    }
    
}
