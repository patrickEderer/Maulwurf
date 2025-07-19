//
//  WerwolfPlayerSettings.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 26.06.25.
//

import Foundation
import SwiftUI

struct WerwolfPlayerSettings: View {
    var engine: WerwolfEngine
    var settings: WerwolfSettingsView
    var screen = UIScreen.main.bounds
    
    @State var editingPlayerIndex: Int? = nil
    @State var slideOffset: (Int, Double, Double) = (-1, 0, 0)
    
    var body: some View {
        VStack {
            titleBar
            
            Spacer(minLength: 100)
            
            VStack {
                if editingPlayerIndex == nil {
                    playersView
                } else {
                    PlayerEditView(engine: engine, settings: self, playerIndex: editingPlayerIndex!)
                }
            }
        }
        
        Spacer()
    }
    
    private var playersView: some View {
        ScrollView {
            VStack {
                ForEach (0..<engine.getPlayers().count, id: \.self) { i in
                    getPlayerView(engine.getPlayers()[i])
                }
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "#0096FF"))
                    .aspectRatio(4, contentMode: .fit)
                    .overlay {
                        Text("+ Add Player")
                            .font(.title2)
                    }
                    .onTapGesture {
                        editingPlayerIndex = engine.getPlayers().count
                        engine.addPlayer(player: WerwolfPlayer(name: "", role: .None, index: editingPlayerIndex!))
                    }
            }
            .padding(.horizontal, 50)
        }.scrollDisabled(checkScrollDisabled())
    }
    
    private func checkScrollDisabled() -> Bool {
        return slideOffset.1 < 0 && slideOffset.1 != -100
    }
    
    private func getPlayerView(_ player: WerwolfPlayer) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.clear)
                .aspectRatio(4, contentMode: .fit)
                .overlay {
                    HStack {
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hex: "#FF0000"))
                            .frame(width: 80)
                            .overlay {
                                Image(systemName: "trash")
                            }
                            .padding(.trailing, 10)
                    }
                }
                .onTapGesture {
                    withAnimation(.bouncy(duration: 0.25)) {
                        engine.removePlayer(player.index)
                        slideOffset.0 = -1
                        slideOffset.1 = 0
                    }
                }
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "#0096FF"))
                .aspectRatio(4, contentMode: .fit)
                .overlay {
                    HStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hex: "#005FD1"))
                            .aspectRatio(1, contentMode: .fit)
                            .overlay {
                                PlayerIcon(player: player, size: 50)
                            }
                        
                        Spacer()
                        
                        Text("\(player.getName())")
                            .font(.system(size: 100))
                            .minimumScaleFactor(0.1)
                            .scaleEffect(0.75)
                        
                        Spacer()
                    }
                }
                .offset(x: slideOffset.0 == player.index ? slideOffset.1 : 0, y: 0)
            
            Color.white.opacity(0.001)
                .onTapGesture {
                    Thread {
                        if slideOffset.0 != -1 {
                            withAnimation(.spring(duration: 0.25)) {
                                slideOffset.0 = -1
                                slideOffset.1 = 0
                            }
                            Thread.sleep(forTimeInterval: 0.125)
                        }
                        editingPlayerIndex = player.index
                    }.start()
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 10)
                        .onChanged { value in
                            if abs(value.translation.height) > abs(value.translation.width) { return }
                            
                            if value.translation.width + slideOffset.2 < 0 {
                                withAnimation(.easeOut(duration: 0.25)) {
                                    slideOffset.0 = player.index
                                    slideOffset.1 = max(value.translation.width + slideOffset.2, -99)
                                }
                            }
                        }
                        .onEnded { value in
                            if abs(value.translation.height) > abs(value.translation.width) { return }
                            
                            if value.translation.width + slideOffset.2 > -99 && value.velocity.width + slideOffset.2 > -100 {
                                withAnimation(.easeOut(duration: 0.25)) {
                                    slideOffset.0 = -1
                                    slideOffset.1 = 0
                                    slideOffset.2 = 0
                                }
                            } else {
                                withAnimation(.easeOut(duration: 0.25)) {
                                    slideOffset.1 = -100
                                    slideOffset.2 = -100
                                }
                            }
                        }
                    )
                .offset(x: slideOffset.0 == player.index && slideOffset.1 == -100 ? -100 : 0, y: 0)
            
        }
    }
    
    private var titleBar: some View {
        HStack {
            Circle()
                .frame(width: 0, height: 0)
                .overlay {
                    Button {
                        if editingPlayerIndex == nil {
                            settings.settingsScreen = .Home
                        } else {
                            editingPlayerIndex = nil
                        }
                    } label: {
                        Image(systemName: "chevron.backward")
                            .scaleEffect(2)
                            .padding(10)
                            .accentColor(.white)
                            .padding(.leading, 50)
                    }
                }
            
            Spacer()
            
            Text("Players")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Spacer()
        }
    }
}
