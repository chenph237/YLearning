//
//  QueueCommon.swift
//  YLearning
//
//  Created by PADDY on 2024/4/18.
//

import Foundation

class Queue<T> {
    private var elements: [T] = []
    var qlock = NSLock()
    func enqueue(_ value: T) {
        qlock.lock()
        defer { qlock.unlock() }
        
        elements.append(value)
    }
    
    func enqueueHead(_ value: T) {
        qlock.lock()
        defer { qlock.unlock() }
        
        elements.insert(value, at: 0)
    }
    
    func dequeue() -> T? {
        qlock.lock()
        defer { qlock.unlock() }
        
        guard !elements.isEmpty else {
            return nil
        }
        return elements.removeFirst()
    }
    
    func clenQueue() {
        qlock.lock()
        defer { qlock.unlock() }
        
        guard !elements.isEmpty else {
            return
        }
        elements.removeAll()
    }
    
    var head: T? {
        qlock.lock()
        defer { qlock.unlock() }
        
        return elements.first
    }
    
    var tail: T? {
        qlock.lock()
        defer { qlock.unlock() }
        return elements.last
    }
    
    var isEmpty: Bool {
        qlock.lock()
        defer { qlock.unlock() }
        return elements.count > 0 ? false : true
    }
    
    var count: Int {
        qlock.lock()
        defer { qlock.unlock() }
        return elements.count
    }
}

