//
//  SQLiteStatement.swift
//  YLearning
//
//  Created by PADDY on 2024/4/19.
//

import Foundation

protocol SQLTable {
    static var createStatement: String { get }
}

/// Static functions and properties are class-level members that belong to the type itself.
/// DBVTable: DBVideoTable
struct SQLiteStatement {
    static let createDBVideoTabel: String =
        """
        CREATE TABLE DBVTable(
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            Title TEXT,
            URL TEXT,
            Category TEXT,
            Tag TEXT,
            Favoriate INTEGER,
            CreatedDate TEXT,
            VideoUUID TEXT
        );
        """
    static let countDBVTable: String = "SELECT COUNT(*) FROM DBVTable;"
    static let queryAllVideoDetailSql: String = "SELECT * FROM DBVTable;"
    static let insertVideoDetailSql: String = "INSERT INTO DBVTable (Title, URL, Category, Tag, Favoriate, CreatedDate, VideoUUID) VALUES (?, ?, ?, ?, ?, ?, ?);"
    static let deleteVideoDetailSql: String = "DELETE FROM DBVTable WHERE VideoUUID = ?;"
    static let updateVideoDetailSql: String = "UPDATE DBVTable SET Title = ?, URL = ?, Category = ?, Tag = ?, Favoriate = ?, CreatedDate = ? WHERE VideoUUID = ?;"
    static let queryVideoIDSql: String = "SELECT VideoUUID FROM DBVTable WHERE URL = ?;"
}
