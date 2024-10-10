//
//  MyShareView.swift
//  YLearning
//
//  Created by PADDY on 2024/5/21.
//

import SwiftUI
import MobileCoreServices
import UniformTypeIdentifiers


/* 檔案屬於MyShareExtension */
struct MyShareView: View {
    var itemProviders: [NSItemProvider]
    var extensionContext: NSExtensionContext?
    //@EnvironmentObject var dataModel: DataModel can't use this
    @State private var sharedURL: String? = nil
    @State private var sharedVID: String? = nil
    @State private var title: String = ""
    @State private var tag: String = ""
    @State private var selectedCategory = SubjecMyCategoryItem.language
    var body: some View {
        GeometryReader {
            let size = $0.size
            let _ = print("\($0)")
            VStack(alignment:.center, spacing: 15) {
                HStack{
                    Group {
                        Spacer()
                        Button("Cancel") {
                            dismiss()
                        }
                        .tint(.red)
                        Spacer()
                        Text(LocalizedStringKey("Import Video"))
                        Spacer()
                        Button("Done") {
                            saveSharingItem()
                            dismiss()
                        }
                        .tint(.red)
                        Spacer()
                    }
                }
                
                LazyVStack{
                    Section(header: Text(LocalizedStringKey("Video")).foregroundColor(.orange)) {
                        Text("URL:\(sharedURL ?? "")")
                            .frame(width: size.width)
                            .lineLimit(2)
                        
                        AsyncImage(url: URL(string: "http://img.youtube.com/vi/\(sharedVID ?? "")/0.jpg")) { image in
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
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                
                Section(header: Text(LocalizedStringKey("Enter image information")).foregroundColor(.orange)) {
                    VStack(alignment: .leading) {
                        TextField("", text: $title, prompt: Text(LocalizedStringKey("Title")).foregroundColor(.orange))
                        HStack{
                            Text(LocalizedStringKey("Category"))
                                .foregroundColor(.orange)
                            Picker("Select category", selection: $selectedCategory) {
                                ForEach(SubjecMyCategoryItem.allCases, id:\.self) { item in
                                    Text(item.rawValue)
                                }
                            }
                            .tint(.red)
                            Spacer()
                        }
                        TextField("", text: $tag, prompt: Text(LocalizedStringKey("Tag")).foregroundColor(.orange))
                    }
                    .padding()
                }
                Spacer()
            }
            .padding(16)
            .onAppear{
                extractItems(size: size)
            }
        }
        
    }
    
    func dismiss() {
        extensionContext?.completeRequest(returningItems: [])
    }
}

#Preview {
    MyShareView(itemProviders: [], extensionContext: nil)
}

extension MyShareView {
    /// @function extractItems
    /// @discussion parsing sharing data
    func extractItems(size: CGSize) {
        print(size)
        DispatchQueue.global(qos: .userInteractive).async {
            //for provider in itemProviders {
            //    provider.registeredTypeIdentifiers.forEach { print( String(describing: $0)) }
            //}
            for provider in itemProviders {
                if provider.hasItemConformingToTypeIdentifier(UTType.plainText.identifier) {
                    provider.loadItem(forTypeIdentifier: UTType.plainText.identifier, options: nil) { text, error in
                        if let text = (text as? String){
                            self.sharedURL = text
                            let (vid, vlist) = self.parsingVideoID(input: text)
                            if let id = vid {
                                print("video id: \(id)")
                                self.sharedVID = id
                            }
                            if let list = vlist {
                                print("video list: \(list)")
                            }
                            //let defaults = UserDefaults(suiteName: "group.com.ws.YLearning")
                            //defaults?.set(text, forKey: "videoURL")
                            //defaults?.synchronize()
                        }
                    }
                } else if provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
                    provider.loadItem(forTypeIdentifier: UTType.url.identifier, options: nil) { url, error in
                        if let url = (url as? URL){
                            print(url.absoluteString)
                            self.sharedURL = url.absoluteString
                            let (vid, vlist) = self.parsingVideoID(input: url.absoluteString)
                            if let id = vid {
                                print("2. video id: \(id)")
                                self.sharedVID = id
                            }
                            if let list = vlist {
                                print("2. video list: \(list)")
                            }
                            //let defaults = UserDefaults(suiteName: "group.com.ws.YLearning")
                            //defaults?.set(text, forKey: "videoURL")
                            //defaults?.synchronize()
                        }
                    }
                }else {
                    print("Not yet!")
                }
            }//for
        }
    }
    
    /// @function parsingVideoID
    /// @discussion parsing the URL to get video ID / video list
    ///     (videoID, list)
    func parsingVideoID(input: String) -> (String?, String?) {
        if input.contains("youtube.com"){
            let idString =  URLComponents(string: input)?.queryItems?.first(where: { $0.name == "v" })?.value
            let listString =  URLComponents(string: input)?.queryItems?.first(where: { $0.name == "list" })?.value
            
            print("idString:\(idString ?? "No video ID")")
            
            return (idString, listString)
        } else if input.contains("youtu.be") {
            let separators = CharacterSet(charactersIn: "/?")
            let component = input.components(separatedBy: separators)
            let idString = component[3]
            
            return (idString, nil)
        }
        print("parsingVideoID: Not found")
        return (nil, nil)
    }
    
    //
    // Private
    //
    
    /// @function saveSharingItem
    /// @discussion Save sharing item
    func saveSharingItem() {
        let userDefaults = UserDefaults(suiteName: "group.com.ws.YLearning")
        userDefaults?.set(sharedURL, forKey: "K_Url")
        userDefaults?.set(title, forKey: "K_Title")
        userDefaults?.set(selectedCategory.rawValue, forKey: "K_Category")
        userDefaults?.set(tag, forKey: "K_Tag")
    }
    
    /// @function placeholderImageVB
    /// @discussion image placeholder
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
