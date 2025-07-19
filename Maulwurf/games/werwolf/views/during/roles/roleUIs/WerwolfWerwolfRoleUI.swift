//
//  WerwolfWerwolfRoleUI.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 25.06.25.
//

import Foundation
import SwiftUI

struct WerwolfWerwolfRoleUI: View {
    var engine: WerwolfEngine
    var screen = UIScreen.main.bounds
    
    @State var selectedPlayer: Int? = nil
    
    var body: some View {
        VStack {
            Text("Wählt ein\nOpfer")
                .minimumScaleFactor(0.1)
                .foregroundColor(Color(hex: "#FF0000"))
                .font(.system(size: 75))
                .multilineTextAlignment(.center)
                .fontWeight(.semibold)
                .ignoresSafeArea(.all)
                .padding(.top, 10)
            
            PlayerGrid(players: engine.getPlayers(), awakePlayersRole: .Werwolf)
                .setColors(colors: (Color(hex: "#EA4D3D").opacity(1 / 3), Color(hex: "#EA4D3D"), Color(hex: "#FF0000")))
                .setBounds(bounds: CGRect(x: 0, y: 0, width: screen.width * 0.9, height: screen.height * 0.6))
                .onClick { selected in
                    if selected.count == 0 {
                        selectedPlayer = nil
                    } else {
                        selectedPlayer = selected[0]
                    }
                }
            
            Button {
                engine.roleActions!.werwolfAction(killedPlayerIndex: selectedPlayer!)
            } label: {
                Text("Töten")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 20, leading: 100, bottom: 20, trailing: 100))
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(selectedPlayer == nil ? .gray : .red)
            )
            .disabled(selectedPlayer == nil)
        }
    }
}
