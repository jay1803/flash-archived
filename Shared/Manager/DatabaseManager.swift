//
//  ModelData.swift
//  flash
//
//  Created by Max Zhang on 2022/4/27.
//

import Foundation
import WCDBSwift

final class DatabaseManager: NSObject {
    static let shared = DatabaseManager()
    
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
        
        let dataBasePath = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true).last! + "/data.db"
        
        database = Database(withPath: dataBasePath)
        
        super.init()
    }
}

extension DatabaseManager {
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
    
    func queryList<T: TableCodable>(properties: [PropertyConvertible], condition: Condition?, orderList: [OrderBy]?, limit: Limit?, offset: Offset?) -> [T]? {
        do {
            let objects: [T] = try database.getObjects(on: properties, fromTable: "\(T.self)", where: condition, orderBy: orderList, limit: limit, offset: offset)
            return objects
        } catch {
            debugPrint("queryList [\(T.self)] error \(error.localizedDescription)")
        }
        return nil
    }
    
    func queryObject<T: TableCodable>(properties: [PropertyConvertible], condition: Condition?, orderList: [OrderBy]?, limit: Limit?, offset: Offset?) -> T? {
        do {
            let object: T? = try database.getObject(on: properties, fromTable: "\(T.self)", where: condition, orderBy: orderList, offset: offset)
            return object
        } catch {
            debugPrint("queryObject [\(T.self)] error \(error.localizedDescription)")
        }
        return nil
    }
    
    func delete<T: TableCodable>(table: T.Type = T.self, condition: Condition?) {
        do {
            try database.delete(fromTable: "\(table.self)", where: condition, orderBy: nil, limit: nil, offset: nil)
        } catch {
            debugPrint("delete table [\(table.self)] error \(error.localizedDescription)")
        }
    }
    
    func begin() throws {
        try database.begin()
    }
    
    func commit() throws {
        try database.commit()
    }
    
    func rollback() throws {
        try database.rollback()
    }
}
