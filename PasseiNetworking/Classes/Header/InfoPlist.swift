//
//  InfoPlist.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 05/11/23.
//

import Foundation

// MARK: - URLScheme

public typealias URLScheme = String

// MARK: - URLType

public struct URLType: Codable {

  public private (set) var role: String?
  public private (set) var iconFile: String?
  public private (set) var urlSchemes: [String]

  // MARK: - Codable

  private enum Key: String, CodingKey {
    case role = "CFBundleTypeRole"
    case iconFile = "CFBundleURLIconFile"
    case urlSchemes = "CFBundleURLSchemes"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: URLType.Key.self)

    role = try container.decodeIfPresent(String.self, forKey: .role)
    iconFile = try container.decodeIfPresent(String.self, forKey: .iconFile)
    urlSchemes = try container.decode([String].self, forKey: .urlSchemes)
  }
}

// MARK: - InfoPlist

public struct InfoPlist: Codable {

  public private (set) var displayName: String?
  public private (set) var bundleId: String
  public private (set) var bundleName: String?
  public private (set) var versionNumber: String?
  public private (set) var buildNumber: String?

  public private (set) var urlTypes: [URLType]?

  // MARK: - Codable

  private enum Key: String, CodingKey {

    case displayName = "CFBundleDisplayName"
    case bundleName = "CFBundleName"

    case bundleId = "CFBundleIdentifier"
    case versionNumber = "CFBundleShortVersionString"
    case buildNumber = "CFBundleVersion"

    case urlTypes = "CFBundleURLTypes"
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: InfoPlist.Key.self)

    bundleId = try container.decode(String.self, forKey: .bundleId)
    versionNumber = try container.decode(String.self, forKey: .versionNumber)
    buildNumber = try container.decode(String.self, forKey: .buildNumber)

    displayName = try? container.decodeIfPresent(String.self, forKey: .displayName)
    bundleName = try? container.decodeIfPresent(String.self, forKey: .bundleName)

    urlTypes = try? container.decodeIfPresent([URLType].self, forKey: .urlTypes)
  }
}
