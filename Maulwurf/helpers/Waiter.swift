//
//  Waiter.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 29.07.25.
//

import Foundation

public class Waiter {
    private let condition = NSCondition()
    private var ready = false
    
    func waitForSignal() {
        condition.lock()
        while !ready {
            condition.wait()
        }
        condition.unlock()
    }
    
    func sendSignal() {
        condition.lock()
        ready = true
        condition.signal()
        condition.unlock()
        Thread.sleep(forTimeInterval: 0.0001)
        ready = false
    }
}
