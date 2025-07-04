//
//  NewRoleButton.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 24.06.25.
//

import Foundation
import SwiftUI

struct WerwolfLockButton: View {
    @State var startHoldingTime: Date? = nil
    @State var holdingTime: Double = 0.0
    
    var onUnlocked: () -> Void
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "#FF0000"))
            
            Circle()
                .fill(Color(hex: "#00FF00"))
                .scaleEffect(startHoldingTime == nil ? 0 : 1)
                .overlay {
                    Image(systemName: "lock")
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .scaleEffect(0.5)
                        .shadow(radius: 5)
                }
                .shadow(radius: 5)
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if startHoldingTime == nil {
                        startHolding()
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeIn(duration: 1)) {
                        startHoldingTime = nil
                        holdingTime = 0
                    }
                }
        )
    }
    
    private func startHolding() {
        withAnimation(.easeOut(duration: 1)) {
            startHoldingTime = Date()
        }
        Thread {
            while startHoldingTime != nil && holdingTime < 1 {
                holdingTime = min(Date().timeIntervalSince(startHoldingTime ?? Date()), 1)
                SensoryFeedback.getInstance().impact(.light)
                
                Thread.sleep(forTimeInterval: 1.0 / 10.0)
            }
            if holdingTime >= 1 {
                onUnlocked()
            }
        }.start()
    }
}
