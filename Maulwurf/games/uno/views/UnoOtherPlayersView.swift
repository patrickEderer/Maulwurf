//
//  UnoOtherPlayersView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 18.08.25.
//

import Foundation
import SwiftUI

struct UnoOtherPlayersView: View {
    @ObservedObject var engine: UnoEngine
    var screen = UIScreen.main.bounds
    
    init(engine: UnoEngine) {
        self.engine = engine
    }
    
    var body: some View {
        HStack {
            ForEach (0..<engine.getRemainingPlayers().count - 1, id: \.self) { i in
                let player = engine.getRemainingPlayers()[i + ( i >= engine.currentPlayerIndex ? 1 : 0)]
                VStack {
                    Text(player.name)
                        .foregroundColor(.white)
                        .bold()
                        .padding(.top, 10)
                        .shadow(radius: 5)
                    
                    PlayerIcon(player: player, size: screen.width / 10)
                        .frame(width: screen.width / 10, height: screen.width / 10)
                        .shadow(radius: 5)
                    
                    ZStack {
                        UnoCardView(card: UnoCardBackside2(colorIndex: player.cards.count == 1 ? -3 : -2), glowing: engine.pulse && player.cards.count == 1)
                            .frame(width: screen.width / 10, height: screen.height / 20)
                            .shadow(radius: 5)
                        
                        Text("\(player.cards.count)")
                            .foregroundColor(.white)
                            .bold()
                    }
                    .padding(.bottom, 10)
                }.padding(.horizontal, 20)
                    .background(
                        ZStack {
                            if player.cards.count == 1 {
                                RoundedRectangle(cornerRadius: 20).stroke(Color(hex:"#00FFFF")).blur(radius: 2)
                                RoundedRectangle(cornerRadius: 20).fill(Color(hex:"#00FFFF").opacity(0.25).darker(by: engine.pulse ? 0.25 : 0))
                            } else {
                                RoundedRectangle(cornerRadius: 20).fill(.white.opacity(0.25))
                            }
                        }
                    )
            }
        }
    }
}

#Preview {
    let _ = UnoEngine.getInstance().start()
    UnoOtherPlayersView(engine: UnoEngine.getInstance())
}
