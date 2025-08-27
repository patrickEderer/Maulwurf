//
//  ContentView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 01.06.25.
//

import SwiftUI

struct GameViewManager: View {
    @State var runningGame: Game = .NONE
    var body: some View {
        switch runningGame {
        case .NONE: GameSelectionView(runningGame: $runningGame)
        case .IMPOSTOR: ImpostorView(engine: ImpostorFactory.getInstance())
        case .WERWOLF: WerwolfView(engine: WerwolfEngine.getInstance())
        case .UNO: UnoViewManager(engine: UnoEngine.getInstance())
        }
    }
}
