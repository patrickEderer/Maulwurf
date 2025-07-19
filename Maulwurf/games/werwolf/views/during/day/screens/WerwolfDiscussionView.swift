//
//  WerwolfDiscussionView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 25.06.25.
//

import Foundation
import SwiftUI

struct WerwolfDiscussionView: View {
    var engine: WerwolfEngine
    var manager: WerwolfDayManager
    var screen = UIScreen.main.bounds
    
    let timerDuration = 60.0
    @State var startSleepingTime: Date?
    @State var sleepingTime: Double = 0.0
    
    var body: some View {
        VStack {
            Text("Diskussion")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 100)
                .shadow(radius: 5)
            
            Spacer()
            
            Text("\(Int(timerDuration - sleepingTime))")
                .font(.system(size: 75))
                .fontWeight(.bold)
                .onAppear {
                    startSleepingThread()
                }
                .shadow(radius: 5)
            
            Spacer()
            
            Button {
                manager.viewIndex = 2
                
            } label: {
                Text("Skip")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 60)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.red)
            )
            .padding(.bottom, 100)
        }
    }
    
    private func startSleepingThread() {
        startSleepingTime = Date().addingTimeInterval(1)
        
        Thread {
            while (sleepingTime < timerDuration) {
                sleepingTime = Date().timeIntervalSince(startSleepingTime!)
                Thread.sleep(forTimeInterval: 1 / 15)
            }
            DispatchQueue.main.sync {
                manager.viewIndex = 2
            }
        }.start()
    }
}
