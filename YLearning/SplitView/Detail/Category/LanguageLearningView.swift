//
//  LanguageLearningView.swift
//  YLearning
//
//  Created by PING HUNG CHEN on 2024/4/25.
//

import SwiftUI

struct LanguageLearningView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var tagAction: Bool = false
    @State var show = false
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            List{
                ForEach(dataModel.filterLibraryArray(category: SubjecMyCategoryItem.language.rawValue), id:\.self) { video in
                    VStack {
                        NavigationLink {
                            //YoutubeView(width: width, height: height)
                            SafariView(url: URL(string: video.URL)!)
                                .navigationBarHidden(true)
                                .ignoresSafeArea()
                        }label: {
                            HStack {
                                ItemImageView(width: width, height: height, fileUrl: video.URL)
                                VStack(alignment: .leading){
                                    Text("Title: \(video.Title)")
                                    Text("Category: \(video.Category)")
                                    Text("Tag: \(video.Tag)")
                                    Text("Created Date: \(video.CreatedDate)")
                                        .font(.footnote)
                                }
                                Spacer()
                                Image(systemName: video.Favoriate == 0 ? "heart" : "heart.fill")
                                    .foregroundColor(.orange)
                                    .onTapGesture {
                                        print("onTapGesture: \(video.Title)")
                                        favoriateButtonClicked(video: video)
                                    }
                                Group {
                                    Text("")
                                    Text("")
                                    Text("")
                                    Text("")
                                    Text("")
                                    Text("")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Language")
            //.accentColor(.orange)
            .toolbar { // Issue: Can't change the button's color
                ToolbarItem(placement: .navigationBarTrailing) { //
                    Menu {
                        ForEach(dataModel.filterTagArray(category: SubjecMyCategoryItem.language.rawValue), id:\.self) { item in
                            Button {
                                dataModel.tagClicked(info: item)
                                //tagAction.toggle()
                            } label: {
                                if #available(iOS 15.0, *) {
                                    HStack {
                                        Text(item.tag)
                                        Image(systemName: item.isChecked ? "checkmark.square" : "square")
                                    }
                                    .foregroundStyle(.orange, .orange)
                                }else {
                                    HStack {
                                        Text(item.tag)
                                        Image(systemName: item.isChecked ? "checkmark.square" : "square")
                                    }
                                }
                            }
                        }
                        
                    } label: {
                        Image(systemName: "tag")
                    }
                    
                }
                
            }
        }
    }
}

#Preview {
    LanguageLearningView()
}

extension LanguageLearningView {
    @ViewBuilder
    private func YLIconImage(sysName: String) -> some View {
        Image(systemName: sysName)
            .foregroundColor(.orange)
    }
}

extension LanguageLearningView {
    
    func favoriateButtonClicked(video: DBVideoDetail) {
        var heart: Int = 0
        for i in 0..<dataModel.library.count {
            if dataModel.library[i].VideoUUID == video.VideoUUID {
                if dataModel.library[i].Favoriate == 0 {
                    dataModel.library[i].Favoriate = 1
                    heart = 1
                }else {
                    dataModel.library[i].Favoriate = 0
                    heart = 0
                }
            }
        }
        let vd = DBVideoDetail(Title: video.Title, URL: video.URL, Category: video.Category, Tag: video.Tag, Favoriate: heart, CreatedDate: video.CreatedDate, VideoUUID: video.VideoUUID)
        //update database
        if !dataModel.updateVideoDetail(video: vd) {
            print("Update database error!!!")
        }
    }
}

