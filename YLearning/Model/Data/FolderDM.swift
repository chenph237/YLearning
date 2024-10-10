//
//  FolderDM.swift
//  YLearning
//
//  Created by PADDY on 2024/4/18.
//

import Foundation
import SwiftUI

extension DataModel {
    /// @function initYTFolder
    /// @discussion init app folder
    func initYTFolder() {
        checkOrCreateFolder(atPath: YLFolders.jsonFolder.rawValue)
    }
    
    /// @function isOnlyUpdateVideoInfo
    /// @discussion if video is exist, update video information
    func isOnlyUpdateVideoInfo(info: VideoInfo) -> Bool {
        let videouuid = queryVideoId(url: info.URL)
        if  videouuid != nil {
            let uuid = UUID(uuidString: videouuid!)
            let data = DBVideoDetail(Title: info.Title, URL: info.URL, Category: info.Category, Tag: info.Tag, Favoriate: info.Favoriate, CreatedDate: getCurrentDate(), VideoUUID: uuid!)
            let _ = updateVideoDetail(video: data)
            updateLibraryInfo(info: data)
            DispatchQueue.main.async {
                self.updateLibrary.toggle()
            }
            return true
        }
        return false
    }
    /// @function parsingJsonData
    /// @discussion parsing Json data 
    func parsingJsonData(info: VideoInfo) {
        print("Import: packet = \(info.URL)")
        
        print("Video Info: \(info.Title), Category: \(info.Category), Tag: \(info.Tag)")
        if isOnlyUpdateVideoInfo(info: info) {
            return
        }
        
        //this video is a new one, saved it.
        let data = DBVideoDetail(Title: info.Title, URL: info.URL, Category: info.Category, Tag: info.Tag, Favoriate: info.Favoriate, CreatedDate: getCurrentDate())
        //add video into library
        DispatchQueue.main.async{
            self.library.append(data)
            print("library count: \(self.library.count)")
        }
        //update database
        insertVideo(video: data)
        
        // check: Iis a new tag?
        if checkTagIsNew(tag: info.Tag) {
            let data = VideoTagInfo(category: info.Category, tag: info.Tag, isChecked: false, tagUUID: UUID())
            DispatchQueue.main.async{
                self.tagArray.append(data)
            }
        }
        
        //deleteURLFile(url: packet.url)
    }
    
    ///
    /// Public
    ///
    
    /// @function importJsonFile
    /// @discussion import Json file
    func importJsonFile(fileURL: URL) {
        do {
            let data = try Data(contentsOf: fileURL)
            
            let videoInfos = try JSONDecoder().decode([VideoInfo].self, from: data)
                    
            for info in videoInfos {
                videoImportQueue.enqueue(info)
            }
        }catch {
            print("Error decoding JSON: \(error)")
        }
    }
    
    /// @function deleteURLFile
    /// @discussion delete URL File
    func deleteURLFile(url: URL) {
        do {
            try FileManager.default.removeItem(at: url)
        }catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    /// @function copySharedJsonFile
    /// @discussion save Json file into document's 'Json' Folder
    func copySharedJsonFile(url: URL) {
        let fileManager = FileManager.default
        let urlFileName = url.lastPathComponent
        if isJSONFile(url: url) {
            let docURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let folderURL = docURL.appendingPathComponent(YLFolders.jsonFolder.rawValue)
            let fileURL = folderURL.appendingPathComponent(urlFileName)
            try? FileManager.default.removeItem(at: fileURL)
            copyFileToFolder(at: url, to: fileURL)
        }else {
            print("The file is not a JSON file.")
        }
    }
    
    /// @function getJsonFilesFromJsonDir
    /// @discussion get JSON file from 'JsonDir'
    func getJsonFilesFromJsonDir() {
        let fileManager = FileManager.default
        let docURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(YLFolders.jsonFolder.rawValue)
        var array: [URL] = []
        do {
            let dirContents = try fileManager.contentsOfDirectory(at: docURL, includingPropertiesForKeys: nil)
            let jsonFiles = dirContents.filter{ $0.pathExtension == "json" }
            array.append(contentsOf: jsonFiles)
            jsonFileInfoArray.removeAll()
            for f in array {
                jsonFileInfoArray.append(JsonFileInfo(url: f, download: false))
            }
            
        }catch {
            print("error: \(error.localizedDescription)")
        }

    }
    
    /// @function checkUserDefaults
    /// @discussion Check UserDefaults from Share Extension
    func checkUserDefaults(){
        let userDefaults = UserDefaults(suiteName: "group.com.ws.YLearning")
        let url = userDefaults?.string(forKey: "K_Url")
        let title = userDefaults?.string(forKey: "K_Title")
        let category = userDefaults?.string(forKey: "K_Category")
        let tag = userDefaults?.string(forKey: "K_Tag")
        
        print("url: \(url ?? "")")
        print("title: \(title ?? "") ")
        print("category: \(category ?? "")")
        print("tag: \(tag ?? "") ")
        //videoImportQueue.enqueue(JsonImportPacket(url: fileURL))
        userDefaults?.set("", forKey: "K_Url")
        userDefaults?.set("", forKey: "K_Title")
        userDefaults?.set("", forKey: "K_Category")
        userDefaults?.set("", forKey: "K_Tag")
        if let url = url, !url.isEmpty {
            let info = VideoInfo(Title: title ?? "", URL: url, Category: category!, Tag: tag ?? "", Favoriate: 0)
            videoImportQueue.enqueue(info)
        }
    }
    
    /// @function checkTagIsNew
    /// @discussion Check tag
    func checkTagIsNew(tag: String) -> Bool{
        for item in tagArray {
            if item.tag == tag {
                return false
            }
        }
        return true
    }
    
    ///
    /// Private
    ///
    
    
    
    /// @function copyFileToPath
    /// @discussion
    private func copyFileToFolder(at sourceURL: URL, to destinationURL: URL) {
        let fileManager = FileManager.default
        
        do {
            try fileManager.copyItem(at: sourceURL, to: destinationURL)
            print("File copied successfully from \(sourceURL.absoluteString) to \(destinationURL.absoluteString)")
            getJsonFilesFromJsonDir()
        } catch {
            print("Error copying file: \(error.localizedDescription)")
        }
    }
    
    /// @function checkOrCreateFolder
    /// @discussion If the folder doesn't exist then create it
    private func checkOrCreateFolder(atPath path: String) {
        let fileManager = FileManager.default
        var isDirectory: ObjCBool = false
        
        let docURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let newFolderURL = docURL.appendingPathComponent(path)
        
        //check if the folder exists
        if fileManager.fileExists(atPath: newFolderURL.path , isDirectory: &isDirectory) {
            if isDirectory.boolValue {
                print("Folder already exists at path: \(path)")
                return
            }else {
                // File exists at specified path, but it's not a folder
                print("A file with the same name exists at path: \(path)")
                return
            }
        }else {
            // Folder doesn't exist, create it
            do {
                try fileManager.createDirectory(at: newFolderURL, withIntermediateDirectories: true, attributes: nil)
                print("Folder created at path: \(path)")
                return
            } catch {
                print("Error creating folder: \(error.localizedDescription)")
                return
            }
        }
    }
    
    /// @function isJSONFile
    /// @discussion If the file is a Json file then return true
    private func isJSONFile(url: URL) -> Bool {
        let fileExtension = url.pathExtension.lowercased()
        return fileExtension == "json"
    }

}
