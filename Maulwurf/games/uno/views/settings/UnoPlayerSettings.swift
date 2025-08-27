//
//  WerwolfPlayerSettings.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 26.06.25.
//

import Foundation
import SwiftUI

struct UnoPlayerSettings: View {
    var manager: UnoViewManager
    var settings: UnoSettingsView
    var screen = UIScreen.main.bounds
    @ObservedObject var updater = Updater.getInstance()
    
    @State var editingPlayerIndex: Int? = nil
    @State var slideOffset: (Int, Double, Double) = (-1, 0, 0)
    
    var body: some View {
        VStack {
            titleBar
                .padding(.top, 50)
            
            Spacer(minLength: 100)
            
            VStack {
                if editingPlayerIndex == nil {
                    playersView
                } else {
                    UnoPlayerEditView(manager: manager, settings: settings, playerIndex: editingPlayerIndex!)
                }
            }
        }
        
        Spacer()
    }
    
    private var playersView: some View {
        ScrollView {
            VStack {
                ForEach (0..<manager.engine.players.count, id: \.self) { i in
                    getPlayerView(manager.engine.players[i], index: i)
                }
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: "#0096FF"))
                    .aspectRatio(4, contentMode: .fit)
                    .overlay {
                        Text("+ Add Player")
                            .font(.title2)
                    }
                    .onTapGesture {
                        editingPlayerIndex = manager.engine.players.count
                        manager.engine.addPlayer(player: UnoPlayer(name: "Player \(manager.engine.players.count + 1)"))
                    }
            }
            .padding(.horizontal, 50)
        }.scrollDisabled(checkScrollDisabled())
            .frame(height: screen.height * 0.75)
    }
    
    private func checkScrollDisabled() -> Bool {
        return slideOffset.1 < 0 && slideOffset.1 != -100
    }
    
    private func getPlayerView(_ player: UnoPlayer, index: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(.clear)
                .aspectRatio(4, contentMode: .fit)
                .overlay {
                    HStack {
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hex: player.isPlaying ? "#AAAAAA" : "#888888"))
                            .frame(width: 80)
                            .overlay {
                                Image(systemName: player.isPlaying ? "person.fill.checkmark" : "person.slash")
                            }
                    }
                }
                .onTapGesture {
                    withAnimation(.bouncy(duration: 0.25)) {
                        player.isPlaying.toggle()
                        
                        manager.engine.savePlayers()
                        
                        updater.update()
                        
                    }
                }
                .offset(x: -100)
            
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
                        manager.engine.removePlayer(index)
                        slideOffset.0 = -1
                        slideOffset.1 = 0
                        manager.engine.savePlayers()
                    }
                }
            
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(hex: "#0096FF").darker(by: player.isPlaying ? 0 : 0.5))
                .aspectRatio(4, contentMode: .fit)
                .overlay {
                    HStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hex: "#005FD1").darker(by: player.isPlaying ? 0 : 0.5))
                            .aspectRatio(1, contentMode: .fit)
                            .overlay {
                                PlayerIcon(player: player, size: 50)
                            }
                        
                        Spacer()
                        
                        Text("\(player.name)")
                            .font(.system(size: 100))
                            .minimumScaleFactor(0.1)
                            .scaleEffect(0.75)
                        
                        Spacer()
                    }
                }
                .offset(x: slideOffset.0 == index ? slideOffset.1 : 0, y: 0)
            
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
                        editingPlayerIndex = index
                    }.start()
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 10)
                        .onChanged { value in
                            if abs(value.translation.height) > abs(value.translation.width) { return }
                            
                            if value.translation.width + slideOffset.2 < 0 {
                                withAnimation(.easeOut(duration: 0.25)) {
                                    slideOffset.0 = index
                                    slideOffset.1 = max(value.translation.width + slideOffset.2, -189)
                                }
                            }
                        }
                        .onEnded { value in
                            if abs(value.translation.height) > abs(value.translation.width) { return }
                            
                            if value.translation.width + slideOffset.2 > -189 && value.velocity.width + slideOffset.2 > -100 {
                                withAnimation(.easeOut(duration: 0.25)) {
                                    slideOffset.0 = -1
                                    slideOffset.1 = 0
                                    slideOffset.2 = 0
                                }
                            } else {
                                withAnimation(.easeOut(duration: 0.25)) {
                                    slideOffset.1 = -190
                                    slideOffset.2 = -190
                                }
                            }
                        }
                    )
                .offset(x: slideOffset.0 == index && slideOffset.1 == -190 ? -190 : 0, y: 0)
            
        }
    }
    
    private var titleBar: some View {
        HStack {
            Circle()
                .frame(width: 0, height: 0)
                .overlay {
                    Button {
                        if editingPlayerIndex == nil {
                            settings.showPlayerSettings = false
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
