//
//  View.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 01.06.25.
//

import Foundation
import SwiftUI

struct ImpostorView: View {
    @ObservedObject var engine: ImpostorEngine
    
    var body: some View {
        switch engine.gameState {
        case .Settings:
            VStack {
                ImpostorSettingsView(engine: engine)
            }
        case .ShowingCards:
            VStack {
                ImpostorShowingCardView(engine: engine)
            }
        case .Running:
            VStack {
                ImpostorRunningView(engine: engine)
            }
        case .Done:
            VStack {
                ImpostorDoneView(engine: engine)
            }
        }
    }
}
