//
//  YLearningApp.swift
//  YLearning
//
//  Created by PADDY on 2024/4/16.
//

import SwiftUI

@main
struct YLearningApp: App {
    @StateObject var dataModel: DataModel = DataModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataModel)
                //.environment(\.locale, .init(identifier: "de")) //測試localization
                .onOpenURL { url in
                    // Handle the received file URL
                    print("Received file URL: \(url)")
                    dataModel.copySharedJsonFile(url: url)
                }
        }
    }
}
