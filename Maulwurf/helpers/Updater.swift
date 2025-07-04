//
//  Updater.swift
//  GymApp2
//
//  Created by Ederer Patrick on 03.02.25.
//

import Foundation

class Updater: ObservableObject {
    private static var INSTANCE: Updater? = nil
    
    private var lastUpdate: Date? = nil
    
    init() {}
    
    public static func getInstance() -> Updater {
        if (INSTANCE == nil) {
            INSTANCE = Updater()
        }
        
        return INSTANCE!
    }
    
    @Published var updater: Bool = false;
    
    func getLastUpdate() -> Date? {
        return lastUpdate
    }
    
    func update() {
        updater = !updater
        lastUpdate = Date.now
    }
}
