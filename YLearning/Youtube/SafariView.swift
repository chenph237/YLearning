//
//  SafariView.swift
//  YLearning
//
//  Created by PING HUNG CHEN on 2024/4/17.
//

import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    let url: URL?
    //let onFinished: () -> Void
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let controller = SFSafariViewController(url: url ?? URL(string: "https://www.apple.com/tw/")!)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
        uiViewController.modalPresentationStyle = .fullScreen
    }
    
    //如果你需要在 UIKit 中使用委託 (delegate) 並與 SwiftUI 溝通，就必須實現 makeCoordinator 方法
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func backAction() {
        presentationMode.wrappedValue.dismiss()
    }
    
    class Coordinator: NSObject, SFSafariViewControllerDelegate {
        let parent: SafariView

        init(_ parent: SafariView) {
            self.parent = parent
        }

        func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
            //parent.onFinished()
            print("Dismiss")
            //controller.removeFromParent()
            //controller.dismiss(animated: true, completion: nil)
            self.parent.backAction()
        }
        
        func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
            print("URLL: \(URL.absoluteString)")
            return []
        }
    }
}
