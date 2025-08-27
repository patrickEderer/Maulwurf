//
//  UnoCardActionHandler.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 26.07.25.
//

import Foundation
import SwiftUI

class UnoCardTwoPlayerActionHandler {
    var engine: UnoEngine
    var hasRunOnPlaceFunc = false
    var saveVars: [String: String] = [:]

    init(engine: UnoEngine) {
        self.engine = engine
    }
    
    func saveVar(key: String, val: String) {
        saveVars[key] = val
    }
    
    func getSaveVar(key: String) -> String {
        return saveVars[key]!
    }
    
    func runOnPlace(_ function: @escaping () -> Void) {
        if hasRunOnPlaceFunc { return }
        function()
    }

    func reset() {

    }
    
    func skipPlayer() {
        engine.skipPlayers(1)
    }
    
    func endAction() {
        hasRunOnPlaceFunc = false
        withAnimation(.easeOut(duration: 0.25)) {
            engine.activeCardUI = nil
        }
    }

    func endTurn(nextPlayer: Bool = true) {
        hasRunOnPlaceFunc = false
        engine.endTurn(nextPlayer: nextPlayer)
    }

    func otherPlayer() {
        print("<2 ACTION> Other Player")
        engine.nextPlayer()
    }

    func drawCards(indexOffset: Int = 1, _ count: Int, reason: UnoDrawReason) {
        engine.drawCards(
            indexOffset: indexOffset,
            count,
            reason: reason
        )
    }
}
