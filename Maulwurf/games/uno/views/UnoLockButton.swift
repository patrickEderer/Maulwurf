//
//  NewRoleButton.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 24.06.25.
//

import Foundation
import SwiftUI

struct UnoLockButton: View {
    @State var startHoldingTime: Date? = nil
    @State var holdingTime: Double = 0.0

    var onUnlocked: () -> Void

    var body: some View {
        ZStack {
            Circle()
                .fill(Color(hex: "#000000"))

            VStack {
                HStack {
                    Rectangle()
                        .fill(Color(hex: "#FFFF00"))
                        .padding(-5)
                    Rectangle()
                        .fill(Color(hex: "#00FF00"))
                        .padding(-5)
                }
                HStack {
                    Rectangle()
                        .fill(Color(hex: "#0000FF"))
                        .padding(-5)
                    Rectangle()
                        .fill(Color(hex: "#FF0000"))
                        .padding(-5)
                }
            }
            .shadow(radius: 5)
            .mask {
                    Circle()
                        .scaleEffect(startHoldingTime == nil ? 0 : 1)
                }

            Circle()
                .fill(.clear)
                .overlay {
                    Image(systemName: "lock")
                        .resizable()
                        .interpolation(.none)
                        .scaledToFit()
                        .scaleEffect(0.5)
                        .shadow(radius: 5)
                }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if startHoldingTime == nil {
                        startHolding()
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeIn(duration: 0.3)) {
                        startHoldingTime = nil
                        holdingTime = 0
                    }
                }
        )
    }

    private func startHolding() {
        withAnimation(.easeOut(duration: 0.5)) {
            startHoldingTime = Date()
        }
        Thread {
            while startHoldingTime != nil && holdingTime < 0.5 {
                holdingTime = min(
                    Date().timeIntervalSince(startHoldingTime ?? Date()),
                    0.5
                )
                SensoryFeedback.getInstance().impact(.light)

                Thread.sleep(forTimeInterval: 1.0 / 10.0)
            }
            if holdingTime >= 0.5 {
                onUnlocked()
            }
        }.start()
    }
}

#Preview {
    UnoLockButton {
        print("UNLOCKED")
    }
}
