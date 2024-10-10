//
//  ExportDatabaseView.swift
//  YLearning
//
//  Created by PADDY on 2024/4/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct ExportDatabaseView: View {
    @State private var showShareSheet = false
    var body: some View {
        VStack {
            Button {
                showShareSheet = true
            }label: {
                Text("Export database")
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: getDatabaseFileURL())
        }
    }
}

#Preview {
    ExportDatabaseView()
}

extension ExportDatabaseView {
    func getDatabaseFileURL() -> [URL] {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("database")
            .appendingPathExtension("db")
        return [fileURL]
    }
}

