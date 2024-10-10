//
//  MainUIView.swift
//  YLearning
//
//  Created by PADDY on 2024/4/16.
//

import SwiftUI

struct MainUIView: View {
    @EnvironmentObject var dataModel: DataModel
    var body: some View {
        VStack {
            SplitUIView()
        }
        .padding()
    }
}

#Preview {
    MainUIView()
}
