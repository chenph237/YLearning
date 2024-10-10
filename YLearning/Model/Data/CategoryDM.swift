//
//  CategoryDM.swift
//  YLearning
//
//  Created by PING HUNG CHEN on 2024/5/2.
//

import Foundation

extension DataModel {
    /// @function tagClicked
    /// @discussion clicked the tag button
    func tagClicked(info: VideoTagInfo) {
        for i in 0..<tagArray.count{
            if tagArray[i].tagUUID == info.tagUUID {
                tagArray[i].isChecked.toggle()
            }
        }
        updateTagInfo.toggle()
        print("tag Action")
    }
}
