//
//  YoutubeView.swift
//  YLearning
//
//  Created by PADDY on 2024/4/17.
//

import SwiftUI
import WebKit
///
/// Not used
///
struct YoutubeView: View {
    let width: CGFloat
    let height: CGFloat
    let API_KEY = "AIzaSyBJ_BlXZmWISrgWYtGx3qBZea21lobmXcE"
    var body: some View {
        YouTubePlayer(videoID: "pICAha0nsb0", isPlaying: false)
            .frame(width: width, height: height)
    }
}

struct YouTubePlayer: UIViewRepresentable {
    let videoID: String
    let isPlaying: Bool
    
    func makeCoordinator() -> Coordinator {
            Coordinator()
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        
        guard let baseURL = URL(string: "https://www.youtube.com/embed") else {
            return
        }
        uiView.load(URLRequest(url: baseURL.appendingPathComponent(videoID)))
        
        if isPlaying {
            uiView.evaluateJavaScript("playVideo()", completionHandler: nil)
        } else {
            uiView.evaluateJavaScript("pauseVideo()", completionHandler: nil)
        }
    }
    class Coordinator: NSObject, WKNavigationDelegate {}
}

#Preview {
    YoutubeView(width: 100.0, height: 100.0)
}
