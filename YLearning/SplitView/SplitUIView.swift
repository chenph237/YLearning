//
//  SplitUIView.swift
//  YLearning
//
//  Created by PING HUNG CHEN on 2024/5/7.
//

import SwiftUI

struct SplitUIView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @Environment(\.colorScheme) var colorScheme
    @State private var selection: SidebarItem? = nil
    //@State private var columnVisibility: NavigationSplitViewVisibility = .all
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationSplitView {
                ScrollView {
                    VStack(alignment: .leading){
                        //Text("")
                        Section(header: Text(LocalizedStringKey("Library")).foregroundColor(.orange)) {
                            List(YLSubjects, id:\.self, selection: $selection){ item in
                                NavigationLink(value: item){
                                    HStack(spacing: 8) {
                                        Image(systemName: item.icon)
                                            .frame(width: 24.0)
                                            .foregroundColor(.orange)
                                        Text(LocalizedStringKey(item.title))
                                    }
                                }
                            }
                            .listStyle(.sidebar)
                            .frame(minHeight: minRowHeight * CGFloat(YLSubjects.count+1)) //List 必須指明高度
                        }
                  
                        Section(header: Text(LocalizedStringKey("Category")).foregroundColor(.orange)) {
                            List(YLCategories, id:\.self, selection: $selection){ item in
                                NavigationLink(value: item){
                                    HStack(spacing: 8) {
                                        Image(systemName: item.icon)
                                            .frame(width: 24.0)
                                            .foregroundColor(.orange)
                                        Text(LocalizedStringKey(item.title))
                                    }
                                }
                            }
                            .listStyle(.sidebar)
                            .frame(minHeight: minRowHeight * CGFloat(YLCategories.count+1))
                            
                        }
                        
                        Section(header: Text(LocalizedStringKey("Photo")).foregroundColor(.orange)) {
                            List(photoItems, id:\.self, selection: $selection){ item in
                                NavigationLink(value: item){
                                    HStack(spacing: 12) {
                                        Image(systemName: item.icon)
                                            .frame(width: 24.0)
                                            //.resizable()
                                            //.scaledToFit()
                                            //.frame(width: 16.0, height: 16.0)
                                            .foregroundColor(.orange)
                                        Text(LocalizedStringKey(item.title))
                                    }
                                }
                            }
                            .frame(minHeight: minRowHeight * CGFloat(photoItems.count+1))
                        }
                        Section(header: Text(LocalizedStringKey("Help")).foregroundColor(.orange)) {
                            List(helpItems, id:\.self, selection: $selection){ item in
                                NavigationLink(value: item){
                                    HStack(spacing: 12) {
                                        Image(systemName: item.icon)
                                            .frame(width: 24.0)
                                            //.resizable()
                                            //.scaledToFit()
                                            //.frame(width: 16.0, height: 16.0)
                                            .foregroundColor(.orange)
                                        Text(LocalizedStringKey(item.title))
                                    }
                                }
                            }
                            .frame(minHeight: minRowHeight * CGFloat(helpItems.count+1))
                        }
                    }
                    //.toolbarBackground(.orange, for: .navigationBar)
                    //.toolbarBackground(.visible, for: .navigationBar)
                    .navigationTitle(LocalizedStringKey("Learning"))
                    .navigationBarTitleDisplayMode(.inline)
                }
            }detail: {
                if selection == nil || selection?.title == MySubjectItem.all.rawValue {
                    DetailAllView()
                        //.foregroundStyle(colorScheme == .dark ? .black : .white)
                }else if selection?.title == MySubjectItem.favoriate.rawValue {
                    DetailFavoritesView()
                }else if selection?.title == MySubjectItem.search.rawValue {
                    DetailSearchView()
                }else if selection?.title == MySubjectItem.importJson.rawValue {
                    DetailImportJsonView()
                }else {
                    DetailCategoryView(category: selection?.title)
                }
            }
            //.accentColor(.orange)
        }else {
            Text("iOS Version under 16.0")
        }
    }
}

#Preview {
    SplitUIView()
}
