//
//  WebView.swift
//  YLearning
//
//  Created by PING HUNG CHEN on 2024/4/17.
//

import SwiftUI
import WebKit

///
/// Not used
///
struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        let wkWebView = WKWebView()
        //wkWebView.isOpaque = false
        //wkWebView.backgroundColor = UIColor(Color.black)
        wkWebView.navigationDelegate = context.coordinator
        return wkWebView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
        print("URL: \(uiView.url?.absoluteString ?? "")")
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
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
