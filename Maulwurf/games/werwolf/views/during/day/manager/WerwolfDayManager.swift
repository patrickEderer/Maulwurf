//
//  WerwolfDayManager.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 25.06.25.
//

import Foundation
import SwiftUI

struct WerwolfDayManager: View {
    var engine: WerwolfEngine
    
    @State var viewIndex = 0
    @State var votes: [Int: Int] = [:]
    
    var body: some View {
        switch viewIndex {
        case 0: AnyView(WerwolfNewDayView(engine: engine, manager: self))
        case 1: AnyView(WerwolfDiscussionView(engine: engine, manager: self))
        case 2: AnyView(WerwolfVoteView(engine: engine, manager: self))
        case 3: AnyView(WerwolfVoteResultView(engine: engine, manager: self))
        default: AnyView(Text(":(").font(.largeTitle))
        }
    }
    
    public func killAllMarkedPlayers() {
        let killMarkedPlayers = engine.roleActions!.getKillMarkedPlayers()
        
        for i in killMarkedPlayers {
            let player = engine.getPlayers()[i]
            player.isAlive = false
            if player.inLoveWith != nil {
                engine.getPlayers()[player.inLoveWith!].isAlive = false
            }
        }
        
        engine.roleActions!.resetMarkedPlayers()
    }
}
