//
//  JsonFileInfo.swift
//  YLearning
//
//  Created by PING HUNG CHEN on 2024/4/18.
//

import Foundation

class JsonFileInfo: Equatable, Hashable, Comparable {
    var url: URL
    var download: Bool
    init(url: URL, download: Bool) {
        self.url = url
        self.download = download
    }
    
    static func == (lhs: JsonFileInfo, rhs: JsonFileInfo) -> Bool {
        return lhs.url == rhs.url
    }
    static func > (lhs: JsonFileInfo, rhs: JsonFileInfo) -> Bool {
        return lhs.url.lastPathComponent.lowercased()  > rhs.url.lastPathComponent.lowercased()
    }
    static func < (lhs: JsonFileInfo, rhs: JsonFileInfo) -> Bool {
        let ll = lhs.url.lastPathComponent.lowercased()
        let rr = rhs.url.lastPathComponent.lowercased()
        let ret = (ll < rr)
        return ret
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}
