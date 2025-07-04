//
//  WerwolfRoleUISleepingView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 24.06.25.
//

import Foundation
import SwiftUI

struct WerwolfRoleUISleepingView: View {
    let sleepDuration = 3.0
    @State var startSleepingTime: Date?
    @State var sleepingTime: Double = 0.0
    
    var onDone: () -> Void
    
    var body: some View {
        VStack {
            Text("Schläft wieder ein...")
                .font(.title)
            Text("\(Int(sleepDuration - sleepingTime))")
                .font(.largeTitle)
                .fontWeight(.bold)
                .onAppear {
                    startSleepingThread()
                }
        }
    }
    
    private func startSleepingThread() {
        startSleepingTime = Date().addingTimeInterval(1)
        
        Thread {
            while (sleepingTime < sleepDuration) {
                sleepingTime = Date().timeIntervalSince(startSleepingTime!)
                Thread.sleep(forTimeInterval: 1 / 15)
            }
            DispatchQueue.main.sync {
                onDone()
            }
        }.start()
    }
}
