//
//  WerwolfNewDayView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 25.06.25.
//

import Foundation
import SwiftUI
import UIKit

struct WerwolfNewDayView: View {
    var engine: WerwolfEngine
    var manager: WerwolfDayManager
    var screen = UIScreen.main.bounds
    
    var body: some View {
        ZStack {
            Image("werwolf.backboard")
                .resizable()
                .frame(width: screen.width * 0.9, height: screen.height / 2)
                .mask(
                    RoundedRectangle(cornerRadius: 10)
                )
            
            VStack {
                Text("New Day")
                    .font(.title)
                
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(hex: "#8C6A41"))
                    .frame(width: 200, height: 3)
                
                Text("Tote: \(engine.roleActions!.getKillMarkedPlayers().map { engine.getPlayers()[$0].getName() }.joined(separator: ", "))")
            }
            
            VStack {
                Spacer()
                
                Text("Tap to continue")
                
                Spacer()
                    .frame(height: 100)
            }
            
            Rectangle()
                .fill(.white.opacity(0.001))
                .ignoresSafeArea(.all)
        }.onTapGesture {
            manager.killAllMarkedPlayers()
            manager.viewIndex = 1
        }
    }
}
