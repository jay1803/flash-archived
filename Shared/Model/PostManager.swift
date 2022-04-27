//
//  ModelData.swift
//  flash
//
//  Created by Max Zhang on 2022/4/27.
//

import Foundation
import WCDBSwift

final class PostManager: NSObject {
    static let shared = PostManager()
    
    private let database: Database
    
    private override init() {
        
        Database.globalTrace { (err: Error) in
            print("WCDBSwift err: \(err)")
        }
        Database.globalTrace { (sql: String) in
            print("WCDBSwift sql: \(sql)")
        }
        Database.globalTrace { tag, dict, num in
            print("WCDBSwift tag: \(tag ?? -1); num: \(num); dict: \(dict)")
        }
        
        // 初始化数据库
        let dataBasePath = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true).last! + "/data.db"
        
        database = Database(withPath: dataBasePath)
        
        super.init()
    }
}

extension PostManager {
    func create<T: TableCodable>(table: T.Type) {
        do {
            try database.create(table: "\(table.self)", of: table)
        } catch {
            debugPrint("Create table [\(table.self)] error \(error.localizedDescription)")
        }
    }
    
    func getTransaction() throws -> Transaction {
        let transaction: Transaction = try database.getTransaction()
        return transaction
    }
    
    func insert<T: TableCodable>(objects: [T]) throws {
        do {
            try database.insert(objects: objects, intoTable: "\(T.self)")
        } catch {
            debugPrint("Insert table [\(T.self)] error \(error.localizedDescription)")
        }
    }
}
