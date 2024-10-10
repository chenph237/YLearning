//
//  SidebarView.swift
//  YLearning
//
//  Created by PADDY on 2024/4/16.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @State private var selection: SidebarItem? = nil
    
    var body: some View {
        if #available(iOS 17.0, *) {
            showSidebarItemView()
                .navigationTitle("Learning")
                .onChange(of: selection){
                    print("Tap \(selection?.title ?? "")")
                    dataModel.sidebarSelection = selection
                }
        } else {
            // Fallback on earlier versions
            showSidebarItemView()
                .navigationTitle("Learning")
                .onChange(of: selection, perform: { item in
                    print("Tap \(selection?.title ?? "")")
                    dataModel.sidebarSelection = selection
                })
        }
    }
}

#Preview {
    SidebarView()
}


extension SidebarView {
    @ViewBuilder
    private func showSidebarItemView() -> some View {
        VStack(alignment: .leading) {
            Form {
                Section(header: Text(LocalizedStringKey("Library"))) {
                    List(YLSubjects, id:\.self, selection: $selection){ item in
                        NavigationLink(value: item){
                            HStack {
                                Image(systemName: item.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32.0, height: 32.0)
                                    .foregroundColor(.orange)
                                    
                                Text(LocalizedStringKey(item.title))
                            }
                        }
                    }
                    .listStyle(.sidebar)
                    .frame(minHeight: minRowHeight * CGFloat(YLSubjects.count+1)) //List 必須指明高度
                }
                
                Section(header: Text(LocalizedStringKey("Category"))) {
                    List(YLCategories, id:\.self, selection: $selection){ item in
                        NavigationLink(value: item){
                            HStack {
                                Image(systemName: item.icon)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 32.0, height: 32.0)
                                    .foregroundColor(.orange)
                                Text(LocalizedStringKey(item.title))
                            }
                        }
                    }
                    .listStyle(.sidebar)
                    .frame(minHeight: minRowHeight * CGFloat(YLCategories.count+1))
                    
                }
                
                Section(header: Text(LocalizedStringKey("Help"))) {
                    List(helpItems, id:\.self, selection: $selection){ item in
                        NavigationLink(value: item){
                            HStack {
                                Image(systemName: item.icon)
                                    .foregroundColor(.orange)
                                    
                                Text(LocalizedStringKey(item.title))
                            }
                        }
                    }
                }
            }
            Spacer()
        }
    }
    
}
