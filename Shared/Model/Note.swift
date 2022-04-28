//
//  Post.swift
//  flash
//
//  Created by Max Zhang on 2022/4/27.
//

import Foundation
import WCDBSwift

class Note: TableCodable, Identifiable {
    var id = UUID()
    var content: String?
    var createdAt: Date?
    var updatedAt: Date?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Note
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case id
        case content
        case createdAt
        case updatedAt
    }
}
