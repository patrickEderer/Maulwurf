//
//  WerwolfLiebespaarRoleUI.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 05.07.25.
//

import Foundation
import SwiftUI

struct WerwolfLiebespaarRoleUI: View {
    var engine: WerwolfEngine
    var screen = UIScreen.main.bounds
    @State var currentPlayerIndex = 0
    @State var slideOffset = 0.0
    @State var buttonDisabled = false
    
    var body: some View {
        let player = engine.getPlayers()[currentPlayerIndex]
        ZStack {
            VStack {
                Spacer()
                    .frame(height: screen.height / 6)
                
                if player.inLoveWith == nil {
                    Spacer()
                        .frame(height: screen.height / 10)
                    
                    Text("Nicht Verliebt")
                        .foregroundColor(Color(hex: "#EB539F"))
                        .font(.title)
                        .bold()
                        .padding(20)
                } else {
                    verliebtUI
                }
            }
            .frame(width: screen.width * 0.75, height: screen.height * 0.5)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#555555"))
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
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#555555"))
                    .offset(y: slideOffset)
            ).simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        buttonDisabled = true
                        withAnimation(.bouncy(duration: 0.2, extraBounce: 0.2)) {
                            slideOffset = min(max(value.translation.height, -(screen.height / 3)), 0)
                        }
                    }
                    .onEnded({ _ in
                        withAnimation(.snappy(duration: 0.5)) {
                            slideOffset = 0
                        }
                        Thread {
                            Thread.sleep(forTimeInterval: 0.5)
                            buttonDisabled = false
                        }.start()
                    })
            )
            .shadow(radius: 5)
        }
        
        VStack {
            Spacer()
            
            Button {
                if currentPlayerIndex >= engine.getPlayers().count - 1 {
                    engine.roleUIScreenState = .Sleeping
                    return
                }
                
                slideOffset = 0
                currentPlayerIndex += 1
            } label: {
                Text("Weiter Geben")
                    .font(.system(size: 20).bold())
                    .foregroundColor(.white)
                    .padding(10)
            }.background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(MaulwurfApp.color)
                    .frame(width: 150)
            )
            .disabled(buttonDisabled)
        }
    }
    
    private var verliebtUI: some View {
        VStack {
            let player = engine.getPlayers()[currentPlayerIndex]
            let lovePlayer = engine.getPlayers()[player.inLoveWith!]
            
            PlayerIcon(player: lovePlayer, size: screen.width / 3)
            
            Text("\(lovePlayer.getName())")
            
            Text("Verliebt")
                .foregroundColor(Color(hex: "#EB539F"))
                .font(.title)
                .bold()
                .padding(20)
        }
    }
}
