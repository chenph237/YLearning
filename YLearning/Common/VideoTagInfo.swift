//
//  VideoTagInfo.swift
//  YLearning
//
//  Created by PING HUNG CHEN on 2024/4/28.
//

import SwiftUI

struct VideoTagInfo: Hashable {
    var belongToWhichCategory: String
    var tag: String
    var isChecked: Bool
    var tagUUID: UUID
    
    init(category belongToWhichCategory: String, tag: String, isChecked: Bool, tagUUID: UUID) {
        self.belongToWhichCategory = belongToWhichCategory
        self.tag = tag
        self.isChecked = isChecked
        self.tagUUID = tagUUID
    }
}
