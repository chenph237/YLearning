//
//  UsualLearningView.swift
//  YLearning
//
//  Created by PING HUNG CHEN on 2024/4/25.
//

import SwiftUI

struct UsualLearningView: View {
    let videoCategory: String?
    @EnvironmentObject var dataModel: DataModel
    var body: some View {
        VStack {
            showUsualLearningView(category: videoCategory)
                .navigationTitle(LocalizedStringKey((videoCategory == nil ? "" : videoCategory!)))
                //.accentColor(.orange)
                .toolbar {
                    Menu {
                        ForEach(dataModel.filterTagArray(category: videoCategory ?? ""), id:\.self) { item in
                            Button {
                                dataModel.tagClicked(info: item)
                                //tagAction.toggle()
                            } label: {
                                if #available(iOS 15.0, *) {
                                    HStack {
                                        Text(item.tag)
                                        Image(systemName: item.isChecked ? "checkmark.square" : "square")
                                    }
                                    //.foregroundStyle(.orange, .orange)
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
                            .foregroundColor(.orange)
                    }
                }
        }
    }
}

#Preview {
    UsualLearningView(videoCategory: "")
}

extension UsualLearningView {
    /// @function showUsualLearningView
    /// @discussion show  view by category
    @ViewBuilder
    func showUsualLearningView(category: String?) -> some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            if category != nil {
                List{
                    ForEach(dataModel.filterLibraryArray(category: category!), id:\.self) { video in
                        VStack {
                            NavigationLink {
                                //YoutubeView(width: width, height: height)
                                if self.videoIsAList(input: video.URL) {
                                    SafariView(url: URL(string: video.URL)!)
                                        .navigationBarHidden(false)
                                        .ignoresSafeArea()
                                }else{
                                    JavascriptYoutubeView(url: video.URL)
                                        .navigationBarHidden(false)
                                        .ignoresSafeArea()
                                }
                            }label: {
                                if dataModel.checkScreenSize(width: width, height: height) {
                                    let _ = print("1. \(width), \(height)")
                                    showItemsForiPad(width: width, height: height, video: video)
                                }else {
                                    let _ = print("2. \(width), \(height)")
                                    showItemsForiPhone(width: width, height: height, video: video)
                                }
                            }
                        }
                    }
                }
            }else {
                List {
                    Text("No Content")
                }
            }
        }
    }
    
    func videoIsAList(input: String) -> Bool{
        if input.contains("youtu.be") || input.contains("youtube.com"){
            let idString =  URLComponents(string: input)?.queryItems?.first(where: { $0.name == "v" })?.value
            let listString =  URLComponents(string: input)?.queryItems?.first(where: { $0.name == "list" })?.value
            
            print("idString:\(idString ?? "No video ID")")
            
            if listString == nil {
                return false
            }
            return true
        }
        return false
    }
    
    @ViewBuilder
    func showItemsForiPhone(width: CGFloat, height: CGFloat, video: DBVideoDetail) -> some View{
        VStack(alignment: .leading) {
            HStack {
                ItemImageView(width: width, height: height, fileUrl: video.URL)
                Spacer()
                Image(systemName: video.Favoriate == 0 ? "heart" : "heart.fill")
                    .foregroundColor(.orange)
                    .onTapGesture {
                        print("onTapGesture: \(video.Title)")
                    }
                Spacer()
            }
            HStack {
                VStack(alignment: .leading){
                    Text("Title: \(video.Title)")
                    Text("Category: \(video.Category)")
                        .font(.footnote)
                    Text("Tag: \(video.Tag)")
                        .font(.footnote)
                    Text("Created Date: \(video.CreatedDate)")
                        .font(.footnote)
                }

                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func showItemsForiPad(width: CGFloat, height: CGFloat, video: DBVideoDetail) -> some View{
        VStack{
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
