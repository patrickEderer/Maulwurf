//
//  WerwolfVoteView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 25.06.25.
//

import Foundation
import SwiftUI

struct WerwolfVoteView: View {
    var engine: WerwolfEngine
    var manager: WerwolfDayManager
    var screen = UIScreen.main.bounds
    
    @State var currentPlayerIndex = 0
    @State var locked = true
    @State var selectedPlayer: Int? = nil
    
    init(engine: WerwolfEngine, manager: WerwolfDayManager) {
        self.engine = engine
        self.manager = manager
        
        repeat {
            currentPlayerIndex += 1
        } while !engine.getPlayers()[currentPlayerIndex].isAlive || currentPlayerIndex >= engine.getPlayers().count
    }
    
    var body: some View {
        VStack {
            if locked {
                lockedView
            } else {
                voteView
            }
        }
    }
    
    var voteView: some View {
        VStack {
            let player = engine.getPlayers()[currentPlayerIndex]
            
            Text("\(player.getName())")
                .font(.system(size: 50))
                .fontWeight(.bold)
                .shadow(radius: 5)
                .padding(.top, 50)
            
            ZStack {
                Image("werwolf.backboard")
                    .resizable()
                    .frame(width: screen.width * 0.9, height: screen.height / 2)
                    .mask(
                        RoundedRectangle(cornerRadius: 10)
                    )
                
                PlayerGrid(players: engine.getPlayers(), awakePlayersRole: .None)
                    .setBounds(bounds: CGRect(x: 0, y: 0, width: screen.width * 0.9, height: screen.height / 2))
                    .setColors(colors: (Color(hex: "#795B39"), Color(hex: "#795B38"), Color(hex: "#503E27")))
                    .onClick { v in
                        if v.isEmpty {
                            selectedPlayer = nil
                        } else {
                            selectedPlayer = v[0]
                        }
                    }
            }
            
            Button {
                manager.votes[selectedPlayer!] = (manager.votes[selectedPlayer!] ?? 0) + 1
                
                if engine.getPlayers().count - 1 <= currentPlayerIndex {
                    manager.viewIndex = 3
                    return
                }
                
                selectedPlayer = nil
                
                locked = true
                
                repeat {
                    currentPlayerIndex += 1
                    if currentPlayerIndex > engine.getPlayers().count - 1 {
                        currentPlayerIndex = engine.getPlayers().count - 1
                        manager.viewIndex = 3
                        return
                    }
                } while !engine.getPlayers()[currentPlayerIndex].isAlive
            } label: {
                Text("Wählen")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 20, leading: 100, bottom: 20, trailing: 100))
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(selectedPlayer == nil ? .gray : Color(hex: "#A37B4B"))
            )
            .disabled(selectedPlayer == nil)
        }
    }
    
    var lockedView: some View {
        ZStack {
            VStack {
                let player = engine.getPlayers()[currentPlayerIndex]
                
                Spacer()
                
                Text("\(player.getName())")
                    .font(.system(size: 50))
                    .fontWeight(.bold)
                    .shadow(radius: 5)
                
                Spacer()
                
                PlayerIcon(player: player, size: screen.width / 2)
                
                Spacer()
                
                Text("Tap to unlock")
                
                Spacer()
            }
            
            Color.white.opacity(0.001)
                .onTapGesture {
                    locked = false
                }
        }
    }
}
