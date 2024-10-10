//
//  DataModel.swift
//  YLearning
//
//  Created by PADDY on 2024/4/16.
//

import SwiftUI
import Foundation

class DataModel: ObservableObject {
    @Published var sidebarSelection: SidebarItem? = nil

    ///YLFolder
    @Published var jsonFileInfoArray: [JsonFileInfo] = []
    
    ///Queue and Task
    var videoImportQueue = Queue<VideoInfo>()       //Queue for http request
    
    var videoDate: String = ""
    //var libraryByDate: [DBVideoDetail] {
    //    return library.sorted(by: { $0.CreatedDate.compare($1.CreatedDate) == .orderedDescending })
    //}
    @Published var updateLibrary: Bool = false
    var library: [DBVideoDetail] = [] {
        didSet {
            library.sort(by: { (lhs, rhs) -> Bool in
                // do sorting based on self.environmentObject
                return lhs.CreatedDate.compare(rhs.CreatedDate) == .orderedDescending
            })
            objectWillChange.send()
        }
    }
    var selectedURL: String = ""
    
    @Published var updateTagInfo: Bool = false
    var tagArray: [VideoTagInfo] = []
    var startDate: String = ""
    ///
    ///Database
    ///
    var sqliteDB: SQLiteDatabase?
    
    ///
    /// For Test Only
    ///
    var isTest: Bool = true
    
    init() {
        initYTFolder()
        /// Database
        initDatabase()
        ///Task
        startRequestQueueTask()
        
        print("library count: \(library.count)")
    }
    
    ///
    /// Public
    ///
    
    /// @function getDate
    /// @discussion return a string of date
    func getCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: Date.now)
        return dateString
    }
    
    func initVideoDate() {
        videoDate = ""
    }
    
    func differentVideoDate(video: DBVideoDetail) -> Bool{
        if videoDate != video.CreatedDate {
            videoDate = video.CreatedDate
            return true
        }
        return false
    }
    
    func getSortedDBVideoDetailArray() -> [DBVideoDetail] {
        
        return library.sorted(by: { $0.CreatedDate.compare($1.CreatedDate) == .orderedDescending })
        
    }
    /// @function filterLibraryArray
    /// @discussion retrieve videos by category
    func filterLibraryArray(category: String) -> [DBVideoDetail] {
        let array = library.filter{$0.Category == category}
        let selectedTagArray = tagArray.filter({$0.isChecked && $0.belongToWhichCategory == category})
        let tagStringArray = selectedTagArray.map{$0.tag}
        startDate = ""
        if selectedTagArray.isEmpty {
            return array
        }
            
        let result = array.filter{tagStringArray.contains($0.Tag)}
        return result
        
    }
    
    /// @function filterLibraryArray  
    /// @discussion retrieve videos by category
    func filterTagArray(category: String) -> [VideoTagInfo] {
        let array = tagArray.filter{$0.belongToWhichCategory == category}
        return array
        
    }
    
    /// @function checkScreenSize
    /// @discussion
    ///    return true:  ipad screen size
    ///    return false: iphone screen size
    func checkScreenSize(width: CGFloat, height: CGFloat) -> Bool {
        if (width + height) > 1400 {
            return true
        }
        return false
    }
    
    
    ///
    /// Private
    ///
    
    
}
