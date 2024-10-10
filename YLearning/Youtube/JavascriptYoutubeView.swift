//
//  JavascriptYoutubeView.swift
//  YLearning
//
//  Created by PING HUNG CHEN on 2024/5/2.
//

import SwiftUI
import WebKit

/// Test OK
struct JavaWebView: UIViewRepresentable {
    let htmlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: JavaWebView
        
        init(_ parent: JavaWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            //            self.parent.handleError?(error.localizedDescription)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("didFinish")
            print("URL: \(webView.url?.absoluteString ?? "")")
        }
        
        
    }
}

struct JavascriptYoutubeView: View {
    let url: String?
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dataModel: DataModel
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            if url != nil {
                JavaWebView(htmlString: generateHtmlByVideoID(url: url!, width: width, height: height))
                    .toolbar{
                        ToolbarItem(placement: .navigationBarTrailing) { //
                            Button {
                                dismiss()
                            }label: {
                                Text("Done")
                            }
                        }
                    }
            }else{
                Text("Video Error!!!")
            }
        }
    }
}

#Preview {
    JavascriptYoutubeView(url: nil)
}

extension JavascriptYoutubeView {
    
    private func generateHtmlByVideoID(url: String, width: CGFloat, height: CGFloat) -> String {
        let tuples = dataModel.parsingVideoID(input: url)
        let bodyBlack = """
            <body style = "background-color:rgb(0 0 0);">
            """
        let bodyWhite = """
            <body style = "background-color:rgb(255 255 255);">
            """
        let BodyBackColorString = (colorScheme == .dark) ?  bodyBlack : bodyWhite
        
        let playVideo = """
                <iframe width=\(width) height=\(height) src="https://www.youtube.com/embed/\(tuples.0 ?? "")" frameborder="0" allowfullscreen></iframe>
            """
        let _ = """
                <iframe width="640" height="480" src="https://www.youtube.com/embed?listType=playlist&list=\(tuples.1 ?? "")" ></iframe>
            """
        let playtarget = playVideo //(tuples.1 == nil) ? playVideo : playList
        let page =
            """
                    <!DOCTYPE html>
                            <html lang="en">
                            <head>
                                <meta charset="UTF-8">
                                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                                <meta name="referrer" content="strict-origin-when-cross-origin" />
                                <title>Embed YouTube Video</title>
                            </head>
                            \(BodyBackColorString)
            
                            \(playtarget)
            
                            </body>
                            </html>
            """
        
        print(page)
        return page
    }
}
