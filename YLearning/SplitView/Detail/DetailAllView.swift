//
//  DetailAllView.swift
//  YLearning
//
//  Created by PADDY on 2024/4/17.
//
import AVFoundation
import SwiftUI

struct DetailAllView: View {
    @EnvironmentObject var dataModel: DataModel
    @State private var thumbnailImage: Image?
    @State private var showSafari = false
    @State private var videoURL: String = ""
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            List{
                ForEach(dataModel.library, id: \.self) { video in
                    HStack{
                        ItemImageView(width: width, height: height, fileUrl: video.URL)
                        VStack(alignment:.leading) {
                            Text("Title: \(video.Title)")
                            Text("Category: \(video.Category)")
                                .font(.footnote)
                            Text("Tag: \(video.Tag)")
                                .font(.footnote)
                            Text("URL: \(video.URL)")
                                .font(.footnote)
                        }
                        Spacer()
                    }
                    .onTapGesture {
                        dataModel.selectedURL = video.URL
                        showSafari.toggle()
                    }
                }
                .onDelete(perform: removeRows)
            }
            .fullScreenCover(isPresented: $showSafari) {
                SafariView(url: URL(string: dataModel.selectedURL))
                    .navigationBarHidden(true)
                    .ignoresSafeArea()
            }
            .onAppear(){
                dataModel.checkUserDefaults() //the video is from Share Extension and it's info. is saved in UserDefaults. 
                dataModel.initVideoDate()
            }
        }
    }
}

#Preview {
    DetailAllView()
}
/*
 SafariView(url: URL(string: video.URL)!)
     .navigationBarHidden(true)
     .ignoresSafeArea()
 */
extension DetailAllView {
    /// @function getVideoThumbnail
    /// @discussion get thumbnail (目前沒用）)
    func getVideoThumbnail(url: String) -> Image?  {
        var image: Image? = nil
        guard let videoURL = URL(string: url) else {
            return nil
        }
        
        print("videoURL: \(videoURL.absoluteString)")
        let asset = AVAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        do {
            let thumbnailCGImage = try generator.copyCGImage(at: .zero, actualTime: nil)
            image = Image(uiImage: UIImage(cgImage: thumbnailCGImage))
        }catch {
            print("Error generating thumbnail: \(error.localizedDescription)")
        }
        if let thumbnailImage = image {
            return thumbnailImage
        }
        
        return nil
    }
    /// @function removeRows
    /// @discussion delete a video
    func removeRows(at offset: IndexSet) {
        let i = offset[offset.startIndex]
        let video = dataModel.library[i]
        dataModel.library.remove(atOffsets: offset)
        dataModel.sqliteDeleteVideo(video: video)
    }
}
