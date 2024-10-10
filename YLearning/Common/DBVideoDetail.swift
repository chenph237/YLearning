//
//  DBVideoDetail.swift
//  YLearning
//
//  Created by PADDY on 2024/4/19.
//

import Foundation
import SwiftUI

struct DBVideoDetail: Hashable {
    var Title: String
    var URL: String
    var Category: String
    var Tag: String
    var Favoriate: Int
    var CreatedDate: String //不用Date
    var VideoUUID: UUID
    
    init(Title: String = "", URL: String = "", Category: String = "", Tag: String = "", Favoriate: Int = 0, CreatedDate: String = "", VideoUUID: UUID = UUID()) {
        self.VideoUUID = VideoUUID
        self.Title = Title
        self.URL = URL
        self.Category = Category
        self.Tag = Tag
        self.Favoriate = Favoriate
        self.CreatedDate = CreatedDate
        
    }
}

struct DBVideoTable: SQLTable {
    static var createStatement: String {
        return SQLiteStatement.createDBVideoTabel
    }
}
