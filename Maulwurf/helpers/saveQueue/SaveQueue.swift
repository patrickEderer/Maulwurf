//
//  SaveQueue.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 25.06.25.
//

import Foundation

public class SaveQueue {
    private static var INSTANCE: SaveQueue? = SaveQueue()
    private var fileSaver = FileSaver.getInstance()
    
    var queues: [SaveQueueKey: Queue] = [:]
    var activeQueueIDs: [SaveQueueKey: UUID] = [:]
    
    private init() {}
    
    public static func getInstance() -> SaveQueue {
        if (INSTANCE == nil) {
            INSTANCE = SaveQueue()
        }
        return INSTANCE!
    }
    
    public func createIfAbsentQueue(queue: SaveQueue.Queue) {
        queues[queue.key] = queue
        
        startQueue(queue: queue)
    }
    
    public func startQueue(queue: Queue) {
        activeQueueIDs[queue.key] = queue.id
        
        Thread {
            Thread.sleep(forTimeInterval: queue.delay)
                
            if self.activeQueueIDs[queue.key] == queue.id {
                DispatchQueue.main.sync {
                    self.fileSaver.save(key: "\(queue.key)", value: queue.valueFunc())
                }
            }
        }.start()
    }
    
    public class Queue {
        var id = UUID()
        var key: SaveQueueKey
        var delay: Double
        var valueFunc: () -> String
        
        // Function to reduce List.join calls or stuff like that
        init(key: SaveQueueKey, delay: Double, valueFunc: @escaping () -> String) {
            self.key = key
            self.delay = delay
            self.valueFunc = valueFunc
        }
    }
}
