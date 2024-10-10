//
//  VideoImageView.swift
//  YLearning
//
//  Created by PADDY on 2024/4/17.
//

import SwiftUI

struct VideoImageView: View {
    let videoID = "uGsh7-6_14A"
    var body: some View {
        AsyncImage(url: URL(string: "http://img.youtube.com/vi/\(videoID)/0.jpg")) { image in
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: 128, height: 128)
                .overlay{
                    image
                        .resizable()
                        .scaledToFit()
                }
                .cornerRadius(15)
                
        } placeholder: {
            placeholderImageVB()
        }
    }
}

#Preview {
    VideoImageView()
}

extension VideoImageView {
    @ViewBuilder
    private func placeholderImageVB() -> some View {
        Image(systemName: "photo")
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 150, height: 150)
            .cornerRadius(20)
            .foregroundColor(.gray)
    }
}
