//
//  DetailImportJsonView.swift
//  YLearning
//
//  Created by PADDY on 2024/4/18.
//

import SwiftUI

struct DetailImportJsonView: View {
    @EnvironmentObject var dataModel: DataModel
    @Environment(\.defaultMinListRowHeight) var minRowHeight
    @State private var isAnimating: Bool = false
    @State private var download: Bool = false
    @State private var showShareSheet = false
    let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        .appendingPathComponent("database")
        .appendingPathExtension("db")
    let animation = Animation
            .easeOut(duration: 3)
            .repeatForever(autoreverses: false)
            .delay(0.5)
    
    var body: some View {
        List{
            ForEach(sortedjsonFileInfoArray(), id:\.self) { info in
                HStack {
                    Text(retriveURLString(url: info.url))
                    Spacer()
                    Button {
                        if download {
                            return
                        }
                        download = true
                        info.download = true
                        dataModel.importJsonFile(fileURL: info.url)
                        Task {
                            try? await Task.sleep(nanoseconds: 500_000_000)
                            self.isAnimating = true
                        }
                        print("download")
                        Task {
                            try? await Task.sleep(nanoseconds: 3_500_000_000)
                            self.isAnimating = false
                            self.download = false
                            info.download = false
                        }
                        
                    }label: {
                        ZStack{
                            Image(systemName: "arrow.down.square")
                                .foregroundColor(.orange)
                                .padding()
                            if download && info.download {
                                ring(for: .blue)
                                    .frame(width: 32.0, height: 32.0)
                                    .animation(isAnimating ? animation : nil, value: isAnimating)
                                    .padding()
                            }
                        }
                        
                    }
                }
                .frame(minHeight: minRowHeight * 2)
                .buttonStyle(.borderless)
                
                
            }
            .onDelete(perform: removeRows)
        }
        .onAppear(){
            print("import .....")
            dataModel.checkUserDefaults() //the video is from Share Extension and it's info. is saved in UserDefaults. 
            dataModel.getJsonFilesFromJsonDir()
        }
        .navigationTitle("JSON")
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(activityItems: [fileURL])
        }
        .toolbar {
             ToolbarItem(placement: .navigationBarTrailing) {
                  Button {
                      showShareSheet = true
                  } label: {
                      Image(systemName: "square.and.arrow.up")
                          .help(Text("Export Database"))
                  }
             }
        }
        
    }
    
}

#Preview {
    DetailImportJsonView()
}

extension DetailImportJsonView {
    func ring(for color: Color) -> some View {
        // Background ring
        Circle()
            .stroke(style: StrokeStyle(lineWidth: 3))
            .foregroundStyle(.tertiary)
            .overlay {
                // Foreground ring
                if #available(iOS 16.0, *) {
                    Circle()
                        .trim(from: 0, to: isAnimating ? 1 : 0)
                        .stroke(color.gradient,
                                style: StrokeStyle(lineWidth: 3, lineCap: .round))
                } else {
                    // Fallback on earlier versions
                }
            }
            .rotationEffect(.degrees(-90))
    }
    
    func removeRows(at offset: IndexSet) {
        let i = offset[offset.startIndex]
        let infoObj = dataModel.jsonFileInfoArray[i]
        dataModel.deleteURLFile(url: infoObj.url)
        dataModel.jsonFileInfoArray.remove(atOffsets: offset)
    }
    
    func retriveURLString(url: URL) -> String {
        let fileURL = url.lastPathComponent
        return fileURL
    }
    
    func sortedjsonFileInfoArray() -> [JsonFileInfo] {
        let array = dataModel.jsonFileInfoArray.sorted(by: < )
        return array
    }
    
}
