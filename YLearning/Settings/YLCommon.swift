//
//  YLCommon.swift
//  YLearning
//
//  Created by PADDY on 2024/4/16.
//

import Foundation

enum YTKeys: String {
    case unknow = "Unknow"
    case category = "Category"
}

enum SettingType: Int {
    case unknow = 0
    case category = 1
}

struct SidebarItem: Codable, Identifiable, Hashable {
    let id: Int
    let icon: String
    let title: String
    
}

struct Constants {
    static let subjectIndex: Int = 0
    static let categoryIndex: Int = 20
    static let photoIndex: Int = 40
    static let helpIndex: Int = 60
}

///
/// Sidebar content
///
enum MySubjectItem: String {
    case all = "All"
    case favoriate = "Favoriate"
    case search = "Search"
    case importJson = "Import"
}

enum SubjecMyCategoryItem: String, CaseIterable {
    case language = "Language"
    case music = "Music"
    case sport = "Sport"
    case cook = "Cook"
    case health = "Health"
    case other = "Other"
}

enum PhotoItem: String {
    case show = "Show"
}
enum HelpItem: String {
    case importJson = "Import Json file"
}

let YLSubjects: [SidebarItem] = [
    SidebarItem(id: Constants.subjectIndex+1, icon: "movieclapper", title: MySubjectItem.all.rawValue),
    SidebarItem(id: Constants.subjectIndex+2, icon: "heart", title: MySubjectItem.favoriate.rawValue),
    SidebarItem(id: Constants.subjectIndex+3, icon: "magnifyingglass", title: MySubjectItem.search.rawValue),
    SidebarItem(id: Constants.subjectIndex+4, icon: "square.and.arrow.down", title: MySubjectItem.importJson.rawValue)
]

let YLCategories: [SidebarItem] = [
    SidebarItem(id: Constants.categoryIndex+1, icon: "textformat", title: SubjecMyCategoryItem.language.rawValue),
    SidebarItem(id: Constants.categoryIndex+2, icon: "music.note", title: SubjecMyCategoryItem.music.rawValue),
    SidebarItem(id: Constants.categoryIndex+3, icon: "figure.disc.sports", title: SubjecMyCategoryItem.sport.rawValue),
    SidebarItem(id: Constants.categoryIndex+4, icon: "frying.pan", title: SubjecMyCategoryItem.cook.rawValue),
    SidebarItem(id: Constants.categoryIndex+5, icon: "figure.mind.and.body", title: SubjecMyCategoryItem.health.rawValue),
    SidebarItem(id: Constants.categoryIndex+6, icon: "square.grid.2x2", title: SubjecMyCategoryItem.other.rawValue)
]

let photoItems: [SidebarItem] = [
    SidebarItem(id: Constants.photoIndex+1, icon: "photo.tv", title: PhotoItem.show.rawValue)
]

let helpItems: [SidebarItem] = [
    SidebarItem(id: Constants.helpIndex+1, icon: "questionmark.circle", title: HelpItem.importJson.rawValue)
]

/// Folder for import shared file
enum YLFolders: String {
    case jsonFolder = "JsonDir"
}
