//
//  DetailSearchView.swift
//  YLearning
//
//  Created by PING HUNG CHEN on 2024/4/17.
//

import SwiftUI

struct DetailSearchView: View {
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    //@Binding var visibility: NavigationSplitViewVisibility
    var body: some View {
        VStack {
            SafariView(url: URL(string: "https://www.youtube.com/")!)
                /*
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: Button {
                    saveImportVideo()
                    //self.mode.wrappedValue.dismiss()
                    visibility = .all
                }label: {
                    //Image(systemName: "arrow.left")
                    Label(LocalizedStringKey("Learning"), systemImage: "lessthan")
                })
                 */
                .ignoresSafeArea()
        }
       
    }
}

#Preview {
    struct Preview: View {
        @State var visibility: NavigationSplitViewVisibility = .all
        var body: some View {
            //DetailSearchView(visibility: $visibility)
            DetailSearchView()
        }
    }
    return Preview()
}


extension DetailSearchView {
    
    func saveImportVideo() {
        print("save import video")
    }
    
    
}
