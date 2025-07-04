//
//  GameSelectionView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 20.06.25.
//

import Foundation
import SwiftUI

struct GameSelectionView: View {
    @Binding var runningGame: Game
    var body: some View {
        Button {
            runningGame = .IMPOSTOR
        } label: {
            Text("Impostor")
        }
        
        Spacer()
            .frame(height: 50)
        
        Button {
            runningGame = .WERWOLF
        } label: {
            Text("The 2. Game")
        }
        
        Spacer()
            .frame(height: 50)
    }
}
