//
//  MaulwurfApp.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 01.06.25.
//

import SwiftUI

@main
struct MaulwurfApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    static var color: Color = .blue
    
    init() {
        Thread {
            Thread.sleep(forTimeInterval: 10)
            SensoryFeedback.getInstance().prepareGenerators()
            print("Generators started")
        }.start()
    }
    
    var body: some Scene {
        WindowGroup {
            GameViewManager()
        }
        
        .onChange(of: scenePhase) { oldValue, newValue in
            switch newValue {
            case .active:
                break
            case .background:
                FileSaver.getInstance().saveToFile()
                break
            case .inactive:
                break
            @unknown default:
                break
            }
        }
    }
}
