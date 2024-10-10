//
//  DatabaseDM.swift
//  YLearning
//
//  Created by PADDY on 2024/4/19.
//

import Foundation

extension DataModel {
    /// @function initDatabase
    /// @discussion init Database
    func initDatabase() {
        do {
            let file = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("database")
                .appendingPathExtension("db")
            print(file.path)
            sqliteDB = try SQLiteDatabase.open(path: file.path)
            print("Successfully opened connection to database.")
        }catch SQLiteError.OpenDatabase(_){
            print("Unable to open database.")
        }catch {
            print("error")
        }
        
        ///Create or Open database table
        if let db = sqliteDB {
            do {
                try db.createTable(table: DBVideoTable.self)
            }catch {
                print(db.errorMessage)
            }
        }
        
        ///Query data
        library = queryAllVideos()
        
        for info in library {
            /// check is a Tag?
            if checkTagIsNew(tag: info.Tag) {
                let data = VideoTagInfo(category: info.Category, tag: info.Tag, isChecked: false, tagUUID: UUID())
                self.tagArray.append(data)
            }
        }
    }
    /// @function insertVideo
    /// @discussion insert a video into database
    func insertVideo(video: DBVideoDetail) {
        if let db = sqliteDB {
            do {
                try db.insertVideoDetail(info: video)
            }catch {
                print(db.errorMessage)
            }
        }
    }
    
    /// @function deleteVideo
    /// @discussion delete a video from database
    func sqliteDeleteVideo(video: DBVideoDetail) {
        if let db = sqliteDB {
            do {
                try db.deleteVideoDetail(videoUUID: video.VideoUUID.uuidString)
            }catch {
                print(db.errorMessage)
            }
        }
    }
    
    func queryAllVideos() -> [DBVideoDetail] {
        var vdList: [DBVideoDetail] = []
        if let db = sqliteDB {
            vdList = db.queryAllVideoDetail()
        }
        return vdList
    }
    /// @function queryVideoId
    /// @discussion return true, if the url is existed
    ///               false, if the url is not existed
    func queryVideoId(url: String) -> String? {
        if let db = sqliteDB {
            let videouuid = db.queryVideoID(videoURL: url)
            print("ID: \(videouuid ?? "")")
            return videouuid
        }
        return nil
    }
    
    /// @function updateVideoDetail
    /// @discussion update video detail
    func updateVideoDetail(video: DBVideoDetail) -> Bool {
        if let db = sqliteDB {
            do {
                try db.updateVideoDetail(info: video)
            }catch {
                print(db.errorMessage)
            }
        }
        return true
    }
    
    /// @function parsingVideoID
    /// @discussion parsing the URL to get video ID / video list
    ///     (videoID, list)
    func parsingVideoID(input: String) -> (String?, String?) {
        if input.contains("youtube.com"){
            let idString =  URLComponents(string: input)?.queryItems?.first(where: { $0.name == "v" })?.value
            let listString =  URLComponents(string: input)?.queryItems?.first(where: { $0.name == "list" })?.value
            
            print("idString:\(idString ?? "No video ID")")
            
            return (idString, listString)
        } else if input.contains("youtu.be") {
            let separators = CharacterSet(charactersIn: "/?")
            let component = input.components(separatedBy: separators)
            let idString = component[3]
            
            return (idString, nil)
        }
        print("parsingVideoID: Not found")
        return (nil, nil)
    }
    /// @function updateLibraryInfo
    /// @discussion
    func updateLibraryInfo(info: DBVideoDetail) {
        for i in 0..<library.count {
            if library[i].VideoUUID == info.VideoUUID{
                library[i].Title = info.Title
                library[i].URL = info.URL
                library[i].Category = info.Category
                library[i].Tag = info.Tag
                library[i].CreatedDate = info.CreatedDate
            }
        }
    }
}
