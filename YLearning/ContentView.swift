//
//  ContentView.swift
//  YLearning
//
//  Created by PADDY on 2024/4/16.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        GeometryReader {
            let _ = print($0.size)
            VStack {
                MainUIView()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
