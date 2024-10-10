//
//  SQliteDB.swift
//  YLearning
//
//  Created by PADDY on 2024/4/19.
//

import Foundation
import SQLite3

enum SQLiteError: Error {
  case OpenDatabase(message: String)
  case Prepare(message: String)
  case Step(message: String)
  case Bind(message: String)
}

///
/// Database
///
final class SQLiteDatabase {
    private let dbPointer: OpaquePointer?
    private init(dbPointer: OpaquePointer?) {
        self.dbPointer = dbPointer
    }
    deinit {
        sqlite3_close(dbPointer)
    }
    
    ///computed property
    var errorMessage: String {
        if let errorPointer = sqlite3_errmsg(dbPointer) {
            let errorMessage = String(cString: errorPointer)
            return errorMessage
        } else {
            return "No error message provided from sqlite."
        }
    }
    
    /// @function open
    /// @discussion open a database
    static func open(path: String) throws -> SQLiteDatabase {
        var db: OpaquePointer?
        if sqlite3_open(path, &db) == SQLITE_OK { //傳回db指標
            return SQLiteDatabase(dbPointer: db) //產生一個database instance
        }else {
            defer {
                if db != nil {
                    sqlite3_close(db)
                }
            }
            if let errorPointer = sqlite3_errmsg(db) {
                let message = String(cString: errorPointer)
                throw SQLiteError.OpenDatabase(message: message)
            }else {
                throw SQLiteError.OpenDatabase(message: "Unknow error, no message provided from sqlite.")
            }
        }
    }
    
    /// @function prepareStatement
    /// @discussion prepare sqlite3 statement
    func prepareStatement(sql: String) throws -> OpaquePointer? {
        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil) == SQLITE_OK else {
            throw SQLiteError.Prepare(message: errorMessage)
        }
        return statement
    }
    
    /// @function createTable
    /// @discussion create table from database
    func createTable(table: SQLTable.Type) throws {
        let createTableStatement = try prepareStatement(sql: table.createStatement)
        
        defer {
            sqlite3_finalize(createTableStatement)
        }
        
        guard sqlite3_step(createTableStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("\(table) table created.")
    }
}//extension

///
/// Operations of database
///
extension SQLiteDatabase {
    /// @function insertVideoDetail
    /// @discussion Insert a video into  database
    func insertVideoDetail(info: DBVideoDetail) throws {
        print("insertVideoDetail: \(info.Title)")
        
        let insertSql = SQLiteStatement.insertVideoDetailSql
        let insertStatement = try prepareStatement(sql: insertSql)
        defer {
            sqlite3_finalize(insertStatement)
        }
        let title: NSString = info.Title as NSString
        let url: NSString = info.URL as NSString
        let category: NSString = info.Category as NSString
        let tag: NSString = info.Tag as NSString
        let favoriate: Int32 = Int32(info.Favoriate)
        let createdDate: NSString = info.CreatedDate as NSString
        let videoUUID: NSString = info.VideoUUID.uuidString as NSString
        guard
            sqlite3_bind_text(insertStatement, 1, title.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 2, url.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 3, category.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 4, tag.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_int(insertStatement, 5, favoriate) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 6, createdDate.utf8String, -1, nil) == SQLITE_OK &&
            sqlite3_bind_text(insertStatement, 7, videoUUID.utf8String, -1, nil) == SQLITE_OK
            
        else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
        print("Successfully inserted row.")
    }
    
    /// @function deleteVideoDetail
    /// @discussion delete a video into  database
    func deleteVideoDetail(videoUUID: String) throws {
        print("deleteVideoDetail")
        let deleteSql = SQLiteStatement.deleteVideoDetailSql
        
        guard let deleteStatement = try? prepareStatement(sql: deleteSql) else {
            print("deleteVideoDetail 1")
            return
        }
        
        let data = videoUUID as NSString
        guard sqlite3_bind_text(deleteStatement, 1, data.utf8String, -1, nil) == SQLITE_OK else {
            print("deleteVideoDetail 2")
            return
        }
                
        if sqlite3_step(deleteStatement) != SQLITE_DONE {
            throw SQLiteError.Step(message: errorMessage)
        }
        
    }
    
    /// @function queryVideoID
    /// @discussion query  a video ID from  database
    func queryVideoID(videoURL: String) -> String? {
        print("queryVideoID")
        let queryVideoIDSql = SQLiteStatement.queryVideoIDSql
        
        guard let queryIDStatement = try? prepareStatement(sql: queryVideoIDSql) else {
            print("queryVideoID 1")
            return nil
        }
        
        let urlString = videoURL as NSString
        guard sqlite3_bind_text(queryIDStatement, 1, urlString.utf8String, -1, nil) == SQLITE_OK else {
            print("queryVideoID 2")
            return nil
        }
        
        guard sqlite3_step(queryIDStatement) == SQLITE_ROW else {
            print("queryVideoID 3")
            return nil
        }
        
        guard let queryString = sqlite3_column_text(queryIDStatement, 0) else{
            return nil
        }
        let uuid = String(cString: queryString)
        return uuid
    }
    
    /// @function updateVideoDetail
    /// @discussion update Video info
    func updateVideoDetail(info: DBVideoDetail) throws {
        print("updateVideoDetail")
        
        let updateSql = SQLiteStatement.updateVideoDetailSql
        let updateStatement = try prepareStatement(sql: updateSql)
        defer {
            sqlite3_finalize(updateStatement)
        }
        
        let title: NSString = info.Title as NSString
        let url: NSString = info.URL as NSString
        let category: NSString = info.Category as NSString
        let tag: NSString = info.Tag as NSString
        let favoriate:Int32 = Int32(info.Favoriate)
        let createdDate: NSString = info.CreatedDate as NSString
        let videoUUID: NSString = info.VideoUUID.uuidString as NSString
        
        guard sqlite3_bind_text(updateStatement, 1, title.utf8String, -1, nil) == SQLITE_OK else {
            print("updateVideoDetail title")
            return
        }
        guard sqlite3_bind_text(updateStatement, 2, url.utf8String, -1, nil) == SQLITE_OK else {
            print("updateVideoDetail url")
            return
        }
        guard sqlite3_bind_text(updateStatement, 3, category.utf8String, -1, nil) == SQLITE_OK else {
            print("updateVideoDetail category")
            return
        }
        guard sqlite3_bind_text(updateStatement, 4, tag.utf8String, -1, nil) == SQLITE_OK else {
            print("updateVideoDetail tag")
            return
        }
        guard sqlite3_bind_int(updateStatement, 5, favoriate) == SQLITE_OK else {
            print("updateVideoDetail favoriate")
            return
        }
        guard sqlite3_bind_text(updateStatement, 6, createdDate.utf8String, -1, nil) == SQLITE_OK else {
            print("updateVideoDetail createdDate")
            return
        }
        guard sqlite3_bind_text(updateStatement, 7, videoUUID.utf8String, -1, nil) == SQLITE_OK else {
            print("updateVideoDetail videoUUID")
            return
        }
        if sqlite3_step(updateStatement) != SQLITE_DONE {
            print("updateVideoDetail setp")
            throw SQLiteError.Step(message: errorMessage)
        }
        return
    }
    
    /// @function queryAllVideoDetail
    /// @discussion query all videos from database
    func queryAllVideoDetail() -> [DBVideoDetail] {
        var list: [DBVideoDetail] = []
        let querySql = SQLiteStatement.queryAllVideoDetailSql
        guard let queryStatement = try? prepareStatement(sql: querySql) else {
            return list
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        
        while(sqlite3_step(queryStatement) == SQLITE_ROW){
            guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
                print("queryResultCol1 Query result is NULL.")
                return list
            }
            guard let queryResultCol2 = sqlite3_column_text(queryStatement, 2) else {
                print("queryResultCol2 Query result is NULL.")
                return list
            }
            guard let queryResultCol3 = sqlite3_column_text(queryStatement, 3) else {
                print("queryResultCol3 Query result is NULL.")
                return list
            }
            guard let queryResultCol4 = sqlite3_column_text(queryStatement, 4) else {
                print("queryResultCol4 Query result is NULL.")
                return list
            }
            
            let favorite = sqlite3_column_int(queryStatement, 5)
            guard let queryResultCol6 = sqlite3_column_text(queryStatement, 6) else {
                print("queryResultCol5 Query result is NULL.")
                return list
            }
            guard let queryResultCol7 = sqlite3_column_text(queryStatement, 7) else {
                print("queryResultCol7 Query result is NULL.")
                return list
            }
            
            let title = String(cString: queryResultCol1)
            let url = String(cString: queryResultCol2)
            let category = String(cString: queryResultCol3)
            let tag = String(cString: queryResultCol4)
            let createdDate = String(cString: queryResultCol6)
            let uuid = String(cString: queryResultCol7)
            
            let vd = DBVideoDetail(Title: title, URL: url, Category: category, Tag: tag, Favoriate: Int(favorite), CreatedDate: createdDate, VideoUUID: UUID(uuidString: uuid)!)
            list.append(vd)
        }
        return list
    }
}
