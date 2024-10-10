//
//  Category1View.swift
//  YLearning
//
//  Created by PADDY on 2024/4/17.
//

import SwiftUI

/// 目前沒用
struct Category1View: View {
    @Binding var show: Bool
    @EnvironmentObject var dataModel: DataModel
    var body: some View {
        //Text("DetailView: \(dataModel.sidebarSelection?.title ?? "")")
        if #available(iOS 16.0, *) {
            NavigationStack {
                GeometryReader { geometry in
                    let width = geometry.size.width
                    let height = geometry.size.height
                    HStack {
                        VStack {
                            NavigationLink {
                                //YoutubeView(width: width, height: height)
                                SafariView(url: URL(string: "https://www.youtube.com/watch?v=hKRUPYrAQoE&list=RDhKRUPYrAQoE&start_radio=1")!)
                                    .navigationBarHidden(true)
                                    .ignoresSafeArea()
                            }label: {
                                VideoImageView()
                            }
                        }
                        .frame(width: width/2, height: height)
                        VStack {
                            Text(LocalizedStringKey(dataModel.sidebarSelection?.title ?? ""))
                        }
                        .frame(width: width/2, height: height)
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

#Preview {
    Category1View(show: .constant(false))
}
