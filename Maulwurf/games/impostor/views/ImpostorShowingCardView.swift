//
//  ImpostorShowingCardView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 02.06.25.
//

import Foundation
import SwiftUI

struct ImpostorShowingCardView: View {
    @ObservedObject var engine: ImpostorEngine
    @State var slideOffset = 0.0
    var screen = UIScreen.main.bounds

    var body: some View {
        Spacer()
        
        let player = engine.players[engine.currentShowingCardIndex]
        ZStack {
            VStack {
                Spacer()
                    .frame(height: screen.height * 0.5 - 100)
                if player.isImpostor {
                    Text("Impostor")
                        .foregroundColor(.red)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(5)
                    
                    if engine.showHint {
                        Text(player.word)
                            .font(.headline)
                            .padding(20)
                    }
                } else {
                    Text(player.word)
                        .font(.title)
                        .padding(20)
                }
            }
            .frame(width: screen.width * 0.75, height: screen.height * 0.5)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#555555"))
            )
            
            VStack {
                Text(player.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(20)
                
                Spacer()
            }
            
            VStack {
                let size = screen.height / 4
                ZStack {
                    //Head
                    Image("head.\(player.imageAssets.0)")
                        .resizable()
                        .interpolation(.none)
                        .frame(width: size * 1.05, height: size * 1.05)
                    
                    //Eyes
                    Image("eyes.\(player.imageAssets.1)")
                        .resizable()
                        .interpolation(.none)
                        .frame(width: size, height: size)
                    
                    //Mouth
                    Image("mouth.\(player.imageAssets.2)")
                        .resizable()
                        .interpolation(.none)
                        .frame(width: size, height: size)
                }
                .offset(y: slideOffset)
            }
            .frame(width: screen.width * 0.75, height: screen.height * 0.5)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#555555"))
                    .offset(y: slideOffset)
            ).simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        
                        withAnimation(.bouncy(duration: 0.2, extraBounce: 0.2)) {
                            slideOffset = min(max(value.translation.height, -300), 0)
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
            if engine.showingSingleCard {
                slideOffset = 0
                engine.gameState = .Running
                engine.currentShowingCardIndex = 0
                engine.showingSingleCard = false
            } else {
                if engine.currentShowingCardIndex < engine.players.count - 1 {
                    slideOffset = 0
                    engine.showNextCard()
                } else {
                    engine.gameState = .Running
                }
            }
        } label: {
            if engine.showingSingleCard {
                Text("Back")
                    .padding(10)
                    .foregroundColor(.white)
            } else {
                if engine.currentShowingCardIndex < engine.players.count - 1 {
                    Text("Next Player")
                        .padding(10)
                        .foregroundColor(.white)
                } else {
                    Text("Start Game")
                        .padding(10)
                        .foregroundColor(.white)
                }
            }
        }.background(
            RoundedRectangle(cornerRadius: 10)
                .fill(MaulwurfApp.color)
                .frame(width: 150)
        )
    }
}
