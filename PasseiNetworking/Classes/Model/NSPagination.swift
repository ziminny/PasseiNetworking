//
//  Lang.swift
//  PasseiOAB
//
//  Created by Vagner Oliveira on 25/12/23.
//

import Foundation

public class NSMetadata: NSModel {
    
    public var itemsPerPage: Int?
    public var totalItems: Int?
    public var currentPage: Int?
    public var totalPages: Int?
    public var sortBy: Array<Array<String>?>?
    
    public init(itemsPerPage: Int? = nil, totalItems: Int? = nil, currentPage: Int? = nil, totalPages: Int? = nil, sortBy: Array<Array<String>?>? = nil) {
        self.itemsPerPage = itemsPerPage
        self.totalItems = totalItems
        self.currentPage = currentPage
        self.totalPages = totalPages
        self.sortBy = sortBy
    }
    
}

public class NSLinks: NSModel {
    
    public var first: String?
    public var previous: String?
    public var current: String?
    public var next: String?
    public var last: String?
    
    public init(first: String? = nil, previous: String? = nil, current: String? = nil, next: String? = nil, last: String? = nil) {
        self.first = first
        self.previous = previous
        self.current = current
        self.next = next
        self.last = last
    }
}

public class NSPagination<T:NSModel>: NSModel {
    
    public var data: Array<T>?
    public var meta: NSMetadata?
    public var links: NSLinks?
    
    public init(data: Array<T>? = nil, meta: NSMetadata? = nil, links: NSLinks? = nil) {
        self.data = data
        self.meta = meta
        self.links = links
    }
      
}
