//
//  ShareViewController.swift
//  MyShareExtension
//
//  Created by PADDY on 2024/5/21.
//

import UIKit
import Social
import SwiftUI

@objc(ShareViewController)
class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        //view.backgroundColor = .red
        self.isModalInPresentation = true
       
        if let itemProviders = (self.extensionContext!.inputItems.first as? NSExtensionItem)?.attachments {
            // New code added below to host the SwiftUI view, Shareview is a SwiftUI
            //
            let contentView = UIHostingController(rootView: MyShareView(itemProviders: itemProviders, extensionContext: self.extensionContext))
            contentView.view.frame = self.view.frame
            self.view.addSubview(contentView.view)
        
            contentView.view.translatesAutoresizingMaskIntoConstraints = false
            contentView.view.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
            contentView.view.bottomAnchor.constraint (equalTo: self.view.bottomAnchor).isActive = true
            contentView.view.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
            contentView.view.rightAnchor.constraint (equalTo: self.view.rightAnchor).isActive = true
            
        }
       
    }

}
/*
 class ShareViewController: SLComposeServiceViewController {
 
 override func isContentValid() -> Bool {
 // Do validation of contentText and/or NSExtensionContext attachments here
 return true
 }
 
 override func didSelectPost() {
 // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
 
 // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
 self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
 }
 
 override func configurationItems() -> [Any]! {
 // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
 return []
 }
 
 }
 */
