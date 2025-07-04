//
//  WerwolfVoteView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 25.06.25.
//

import Foundation
import SwiftUI

struct WerwolfVoteResultView: View {
    var engine: WerwolfEngine
    var manager: WerwolfDayManager
    var screen = UIScreen.main.bounds
    
    var body: some View {
        ZStack {
            VStack {
                let mostVotedPlayerIndex = mostVotedPlayerIndex()
                let mostVotedPlayer = engine.getPlayers()[mostVotedPlayerIndex]
                
                Spacer()
                
                ZStack {
                    Image("werwolf.backboard")
                        .resizable()
                        .frame(width: screen.width * 0.9, height: screen.height / 2)
                        .mask(
                            RoundedRectangle(cornerRadius: 10)
                        )
                    
                    VStack {
                        Text("\(mostVotedPlayer.getName())")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("\(mostVotedPlayer.role)")
                            .font(.title)
                    }
                }
                
                Spacer()
                
                Text("Tap to continue")
                    .padding(.bottom, 50)
            }
            Rectangle()
                .fill(.white.opacity(0.001))
                .ignoresSafeArea(.all)
        }.onTapGesture {
            manager.viewIndex = 0
            engine.dayNight = .Night
        }
    }
    
    private func mostVotedPlayerIndex() -> Int {
        let votes = manager.votes
        
        var max = 0
        var maxIndex = 0
        
        for entry in votes {
            if entry.value > max {
                max = entry.value
                maxIndex = entry.key
            }
        }
        
        engine.getPlayers()[maxIndex].isAlive = false
        
        return maxIndex
    }
}
