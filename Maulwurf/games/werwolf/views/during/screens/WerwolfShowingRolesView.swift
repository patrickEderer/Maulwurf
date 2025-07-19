//
//  WerwolfShowingCardsView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 24.06.25.
//

import Foundation
import SwiftUI

struct WerwolfShowingRolesView: View {
    @ObservedObject var updater = Updater.getInstance()
    @ObservedObject var engine: WerwolfEngine
    
    var screen = UIScreen.main.bounds
    
    @State var showingPlayerIndex = 0
    @State var slideOffset = 0.0
    
    var body: some View {
        Spacer()
        
        let player = engine.getPlayers()[showingPlayerIndex]
        ZStack {
            let roleColor = player.role.getColor()
            let roleForegroundColor = player.role.getForegroundColor()
            VStack {
                Spacer()
                    .frame(height: screen.height / 4)
                
                Text("\(player.role)")
                    .font(.title)
                    .foregroundColor(roleForegroundColor)
                    .bold()
                    .padding(20)
            }
            .frame(width: screen.width * 0.75, height: screen.height * 0.5)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(roleColor.opacity(max(min((-slideOffset / (screen.height / 5.0) - 0.5) * 4, 1), 0)))
                    .stroke(Color(hex: "#292929"), lineWidth: 5)
                    .background(Color(hex: "#555555").cornerRadius(30))
            )
            
            VStack {
                Text(player.getName())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(20)
                
                Spacer()
            }
            
            VStack {
                let size = screen.height / 4
                
                PlayerIcon(player: player, size: size)
                    .offset(y: slideOffset)
            }
            .frame(width: screen.width * 0.75, height: screen.height * 0.5)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .fill(Color(hex: "#555555"))
                    .offset(y: slideOffset)
            ).simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        
                        withAnimation(.bouncy(duration: 0.2, extraBounce: 0.2)) {
                            slideOffset = min(max(value.translation.height, -(screen.height / 3)), 0)
                        }
                    }
                    .onEnded({ _ in
                        withAnimation {
                            slideOffset = 0
                        }
                    })
            )
            .shadow(radius: 5)
        }
        
        Spacer()
        
        Button {
            if showingPlayerIndex >= engine.getPlayers().count - 1 {
                engine.startGame()
                return
            }
            showingPlayerIndex += 1
        } label: {
            Text("Weiter Geben")
                .padding(10)
                .foregroundColor(.white)
        }.background(
            RoundedRectangle(cornerRadius: 10)
                .fill(MaulwurfApp.color)
                .frame(width: 150)
        )
    }
}
