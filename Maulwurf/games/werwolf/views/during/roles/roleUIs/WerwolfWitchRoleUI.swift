//
//  WerwolfWerwolfRoleUI.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 25.06.25.
//

import Foundation
import SwiftUI

struct WerwolfWitchRoleUI: View {
    var engine: WerwolfEngine
    var screen = UIScreen.main.bounds
    
    @State var selectedPlayer: Int? = nil
    
    @State var slideOffset: Double = 0.0
    
    @State var viewIndex: Int = 0
    
    var body: some View {
        VStack {
            switch viewIndex {
            case 0: healView
            default: killView
            }
        }
    }
    
    var healView: some View {
        VStack {
            let colorChangePercent = slideOffset / (screen.width / 2)
            Spacer()
            
            ZStack {
                VStack {
                    Text("Opfer Heilen?")
                        .foregroundColor(Color(hex: "#D900F8"))
                        .font(.system(size: 75))
                        .multilineTextAlignment(.center)
                        .fontWeight(.semibold)
                        .ignoresSafeArea(.all)
                        .padding(.top, 10)
                    
                    Spacer()
                }
                
                VStack {
                    Spacer()
                        .frame(height: 50)
                    
                    ZStack {
                        mainRect
                        
                        if colorChangePercent > 0 {
                            healRect
                                .opacity(min(colorChangePercent * 2, 1))
                        } else if colorChangePercent < 0 {
                            ignoreRect
                                .opacity(min(colorChangePercent * -2, 1))
                        }
                    }
                    
                    Text("<<< Swipe >>>")
                }
                
                Color.white.opacity(0.001)
                    .allowsHitTesting(true)
                    .ignoresSafeArea(.all)
                    .simultaneousGesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { new in
                                slideOffset = new.translation.width
                            }
                            .onEnded { v in
                                withAnimation(.easeOut(duration: 0.25)) {
                                    var isDone = false
                                    if (v.translation.width > 0 && v.velocity.width > 50) || slideOffset > screen.width / 3 {
                                        slideOffset = screen.width
                                        engine.roleActions!.witchHealAction(heal: true)
                                        isDone = true
                                    } else if (v.translation.width < 0 && v.velocity.width < -50) || slideOffset < -screen.width / 3 {
                                        slideOffset = screen.width * -1
                                        isDone = true
                                    } else {
                                        slideOffset = 0
                                    }
                                    
                                    if isDone {
                                        Thread {
                                            Thread.sleep(forTimeInterval: 0.25)
                                            
                                            viewIndex = 1
                                        }.start()
                                    }
                                }
                            }
                    )
            }
            
            Spacer()
        }
    }
    
    var mainRect: some View {
        VStack {
            let killMarkedPlayer: WerwolfPlayer = !engine.roleActions!.getKillMarkedPlayers().isEmpty ?
                    engine.getPlayers()[engine.roleActions!.getKillMarkedPlayers()[0]] :
                    engine.getPlayers()[0]
            
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(hex: "#D900F8"))
                .overlay {
                    VStack {
                        Text(killMarkedPlayer.getName())
                            .font(.title)
                        
                        PlayerIcon(player: killMarkedPlayer, size: screen.width / 2)
                    }
                }
                .frame(width: screen.width * 0.8, height: screen.height * 0.5)
                .offset(x: slideOffset, y: 0)
        }
    }
    
    var healRect: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(hex: "#00DD00"))
            .overlay {
                VStack {
                    Text("Heilen")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            .frame(width: screen.width * 0.8, height: screen.height * 0.5)
            .offset(x: slideOffset, y: 0)
    }
    
    var ignoreRect: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color(hex: "#888888"))
            .overlay {
                VStack {
                    Text("Ignorieren")
                        .font(.title)
                        .fontWeight(.bold)
                }
            }
            .frame(width: screen.width * 0.8, height: screen.height * 0.5)
            .offset(x: slideOffset, y: 0)
    }
    
    var killView: some View {
        VStack {
            Text("Jemanden Töten?")
                .foregroundColor(Color(hex: "#D900F8"))
                .font(.system(size: 75))
                .multilineTextAlignment(.center)
                .fontWeight(.semibold)
                .ignoresSafeArea(.all)
                .padding(.top, 20)
            
            Spacer()
            
            PlayerGrid(players: engine.getPlayers())
                .setColors(colors: (Color(hex: "#D900F8"), Color(hex: "#D900F8"), Color(hex: "#FFA9FF")))
                .setBounds(bounds: CGRect(x: 0, y: 0, width: screen.width * 0.9, height: screen.height * 0.6))
                .onClick { v in
                    if v.isEmpty {
                        selectedPlayer = nil
                    } else {
                        selectedPlayer = v[0]
                    }
                }
            
            Spacer()
            
            Button {
                engine.roleActions!.witchKillAction(kill: selectedPlayer != nil, player: selectedPlayer)
            } label: {
                Text(selectedPlayer == nil ? "Nein, Skip" : "Töten")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 60)
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(selectedPlayer == nil ? .green : .red)
            )
        }
    }
}
