//
//  ItemImageView.swift
//  YLearning
//
//  Created by PING HUNG CHEN on 2024/4/23.
//
import Foundation
import SwiftUI

struct ItemImageView: View {
    let width: CGFloat
    let height: CGFloat
    let fileUrl: String
    @EnvironmentObject var dataModel: DataModel
    var body: some View {
        let _ = print("\(width), \(height)")
        AsyncImage(url: getYTThumbnail(urlString: fileUrl)) { image in
            Rectangle()
                .foregroundColor(.gray)
                .frame(width: dataModel.checkScreenSize(width: width, height: height) ? 128 : 128, height: dataModel.checkScreenSize(width: width, height: height) ? 128 : 80)
                .overlay{
                    image
                        .resizable()
                        .scaledToFit()
                }
                .cornerRadius(dataModel.checkScreenSize(width: width, height: height) ? 16 : 8)
                
        } placeholder: {
            //placeholderImageVB()
        }
    }
}

#Preview {
    ItemImageView(width: 128, height: 128,  fileUrl: "https://www.youtube.com/watch?v=b1LRqFbL648")
}

extension ItemImageView {
    /// @function getYTThumbnail
    /// @discussion get thumbnail from YouTube video
    func getYTThumbnail(urlString: String) -> URL? {
        print("urlString:\(urlString)")
        let tuples = dataModel.parsingVideoID(input: urlString)
        guard let videoID = tuples.0 else {
            return nil
        }
        
        
        let thumbnailURLString0 = "https://img.youtube.com/vi/\(videoID)/0.jpg"
        print("File URL String:\(thumbnailURLString0)")
        
        return URL(string: thumbnailURLString0)
    }
    
}
