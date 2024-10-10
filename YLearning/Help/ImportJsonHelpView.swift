//
//  ImportJsonHelpView.swift
//  YLearning
//
//  Created by PING HUNG CHEN on 2024/5/8.
//

import SwiftUI

struct ImportJsonHelpView: View {
    let helpText = """
        Step 1: Understanding the file format of a JSON file(e.g., 2024-05-08.json).

        [
            {
                "Title" : "合輯 - Two Steps From Hell",
                "URL" : "https://www.youtube.com/watch?v=pICAha0nsb0&list=RDpICAha0nsb0&start_radio=1",
                "Category" : "Music",
                "Tag" : "game",
                "Favoriate" : 0,
                "CreatedDate" : "",
                "VideoUUID" : ""
            },
            {
                "Title" : "Smooth Piano Jazz Music & Cozy Coffee Shop Ambience",
                "URL" : "https://www.youtube.com/watch?v=OWukOS9TQvQ",
                "Category" : "Music",
                "Tag" : "Jazz",
                "Favoriate" : 0,
                "CreatedDate" : "",
                "VideoUUID" : ""
            }
        ]

        Step 2: The file involves copying the title and URL from YouTube and filling them into a dictionary.

        Step 3: Sharing the JSON file(2024-05-08.json) to an iPhone or iPad by AirDrop.

        Step 4: Once you receive the file via AirDrop, share it with the to the 'YLearing' app.

        Step 5: After completing step 4, you can locate the JSON file by tapping the 'import' item in the Sidebar.

        Step 6: Tap the download icon to save the JSON data to the local database.
"""
    var body: some View {
        ScrollView {
            Text(helpText)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
        }
        .navigationTitle("Import json")
        .padding()
    }
}

#Preview {
    ImportJsonHelpView()
}

extension ImportJsonHelpView {
    
}
