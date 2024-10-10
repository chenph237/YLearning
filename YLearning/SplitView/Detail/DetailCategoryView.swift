//
//  DetailCategoryView.swift
//  YLearning
//
//  Created by PING HUNG CHEN on 2024/4/25.
//

import SwiftUI

struct DetailCategoryView: View {
    let category: String?
    var body: some View {
        if category == SubjecMyCategoryItem.language.rawValue {
            UsualLearningView(videoCategory: SubjecMyCategoryItem.language.rawValue) //LanguageLearningView()
        } else if category == SubjecMyCategoryItem.music.rawValue {
            UsualLearningView(videoCategory: SubjecMyCategoryItem.music.rawValue) //MusicLearningView()
        } else if category == SubjecMyCategoryItem.sport.rawValue {
            UsualLearningView(videoCategory: SubjecMyCategoryItem.sport.rawValue) //SportLearningView()
        } else if category == SubjecMyCategoryItem.cook.rawValue {
            UsualLearningView(videoCategory: SubjecMyCategoryItem.cook.rawValue) //CookLearningView()
        } else if category == SubjecMyCategoryItem.health.rawValue {
            UsualLearningView(videoCategory: SubjecMyCategoryItem.health.rawValue) //HealthLearningView()
        } else {
            if category == HelpItem.importJson.rawValue {
                ImportJsonHelpView()
            }else if category == PhotoItem.show.rawValue{
                ShowPhotoView()
            }else {
                UsualLearningView(videoCategory: nil)
            }
        }
    }
}

#Preview {
    DetailCategoryView(category: "")
}
