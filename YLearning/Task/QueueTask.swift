//
//  QueueTask.swift
//  YLearning
//
//  Created by PADDY on 2024/4/18.
//

import Foundation

extension DataModel {
    
    /// @function startRequestQueueTask
    /// @discussion  Task for processing request packet
    func startRequestQueueTask() {
        Task(priority: .userInitiated) {
            while true {
                if videoImportQueue.isEmpty == false {
                    //print("request queue dequeue")
                    if let request = videoImportQueue.dequeue() {
                        parsingJsonData(info: request)
                    }
                }
                
                do {
                    try await Task.sleep(nanoseconds: 300_000_000) //100ms
                } catch {
                    print("error:\(error)")
                }
            }
        }
    }
}
