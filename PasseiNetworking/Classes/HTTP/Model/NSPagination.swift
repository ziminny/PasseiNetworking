//
//  NSPagination.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 25/12/23.
//

import Foundation

#if os(macOS)
/// Modelo que representa metadados para paginação.
@objc(NSMetadata)
public class NSMetadata: NSModel {
    
    public static var supportsSecureCoding: Bool { true }
    
    public var itemsPerPage: Int?
    public var totalItems: Int?
    public var currentPage: Int?
    public var totalPages: Int?
    public var sortBy: Array<Array<String>?>?
    
    /// Inicializador da classe NSMetadata.
    /// - Parameters:
    ///   - itemsPerPage: Número de itens por página.
    ///   - totalItems: Total de itens disponíveis.
    ///   - currentPage: Página atual.
    ///   - totalPages: Total de páginas.
    ///   - sortBy: Opções de classificação.
    public init(itemsPerPage: Int? = nil, totalItems: Int? = nil, currentPage: Int? = nil, totalPages: Int? = nil, sortBy: Array<Array<String>?>? = nil) {
        self.itemsPerPage = itemsPerPage
        self.totalItems = totalItems
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.sortBy = sortBy
    }
    
    public required init?(coder: NSCoder) {
        itemsPerPage = coder.decodeInteger(forKey: "itemsPerPage")
        totalItems = coder.decodeInteger(forKey: "totalItems")
        currentPage = coder.decodeInteger(forKey: "currentPage")
        totalPages = coder.decodeInteger(forKey: "totalPages")
        sortBy = coder.decodeObject(of: [ NSArray.self, NSArray.self ], forKey: "sortBy") as? Array<Array<String>?>
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(itemsPerPage, forKey: "itemsPerPage")
        coder.encode(totalItems, forKey: "totalItems")
        coder.encode(currentPage, forKey: "currentPage")
        coder.encode(totalPages, forKey: "totalPages")
        coder.encode(sortBy, forKey: "sortBy")
    }
}

/// Modelo que representa links para diferentes páginas.
@objc(NSLinks)
public class NSLinks: NSModel {
    
    public static var supportsSecureCoding: Bool { true }
    
    public var first: String?
    public var previous: String?
    public var current: String?
    public var next: String?
    public var last: String?
    
    /// Inicializador da classe NSLinks.
    /// - Parameters:
    ///   - first: Link para a primeira página.
    ///   - previous: Link para a página anterior.
    ///   - current: Link para a página atual.
    ///   - next: Link para a próxima página.
    ///   - last: Link para a última página.
    public init(first: String? = nil, previous: String? = nil, current: String? = nil, next: String? = nil, last: String? = nil) {
        self.first = first
        self.previous = previous
        self.current = current
        self.next = next
        self.last = last
    }
    
    public required init?(coder: NSCoder) {
        first = coder.decodeObject(forKey: "first") as? String
        previous = coder.decodeObject(forKey: "previous")  as? String
        current = coder.decodeObject(forKey: "current")  as? String
        next = coder.decodeObject(forKey: "next")  as? String
        last = coder.decodeObject(forKey: "last")  as? String
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(first, forKey: "first")
        coder.encode(previous, forKey: "previous")
        coder.encode(current, forKey: "current")
        coder.encode(next, forKey: "next")
        coder.encode(last, forKey: "last")
    }

}

/// Modelo que representa dados paginados.
public class NSPagination<T: NSObject & NSModel>: NSModel {
    
    public static var supportsSecureCoding: Bool { true }
    
    public var data: [T]?
    public var meta: NSMetadata?
    public var links: NSLinks?
    
    /// Inicializador da classe NSPagination.
    /// - Parameters:
    ///   - data: Array de modelos paginados.
    ///   - meta: Metadados da paginação.
    ///   - links: Links para diferentes páginas.
    public init(data: [T]? = nil, meta: NSMetadata? = nil, links: NSLinks? = nil) {
        self.data = data
        self.meta = meta
        self.links = links
    }
    
    public required init?(coder: NSCoder) {
        data = coder.decodeObject(of: NSArray.self, forKey: "data") as? [T]
        meta = coder.decodeObject(forKey: "meta") as? NSMetadata
        links = coder.decodeObject(forKey: "links") as? NSLinks
    }
    
    public func encode(with coder: NSCoder) {
        coder.encode(data, forKey: "data")
        coder.encode(meta, forKey: "meta")
        coder.encode(links, forKey: "links")
    }
      
}
#else
/// Modelo que representa metadados para paginação.
public struct NSMetadata: NSModel {
    
    public let itemsPerPage: Int?
    public let totalItems: Int?
    public let currentPage: Int?
    public let totalPages: Int?
    public let sortBy: Array<Array<String>?>?
    
    /// Inicializador da classe NSMetadata.
    /// - Parameters:
    ///   - itemsPerPage: Número de itens por página.
    ///   - totalItems: Total de itens disponíveis.
    ///   - currentPage: Página atual.
    ///   - totalPages: Total de páginas.
    ///   - sortBy: Opções de classificação.
    public init(itemsPerPage: Int? = nil, totalItems: Int? = nil, currentPage: Int? = nil, totalPages: Int? = nil, sortBy: Array<Array<String>?>? = nil) {
        self.itemsPerPage = itemsPerPage
        self.totalItems = totalItems
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.sortBy = sortBy
    }
    
}

/// Modelo que representa links para diferentes páginas.
public final class NSLinks: NSModel {
    
    public let first: String?
    public let previous: String?
    public let current: String?
    public let next: String?
    public let last: String?
    
    /// Inicializador da classe NSLinks.
    /// - Parameters:
    ///   - first: Link para a primeira página.
    ///   - previous: Link para a página anterior.
    ///   - current: Link para a página atual.
    ///   - next: Link para a próxima página.
    ///   - last: Link para a última página.
    public init(first: String? = nil, previous: String? = nil, current: String? = nil, next: String? = nil, last: String? = nil) {
        self.first = first
        self.previous = previous
        self.current = current
        self.next = next
        self.last = last
    }
}

/// Modelo que representa dados paginados.
public final class NSPagination<T: NSModel>: NSModel {
    
    public let data: Array<T>?
    public let meta: NSMetadata?
    public let links: NSLinks?
    
    /// Inicializador da classe NSPagination.
    /// - Parameters:
    ///   - data: Array de modelos paginados.
    ///   - meta: Metadados da paginação.
    ///   - links: Links para diferentes páginas.
    public init(data: Array<T>? = nil, meta: NSMetadata? = nil, links: NSLinks? = nil) {
        self.data = data
        self.meta = meta
        self.links = links
    }
      
}
#endif

