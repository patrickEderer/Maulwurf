//
//  UnoCardActionHandler.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 26.07.25.
//

import Foundation
import SwiftUI

class UnoCardActionHandler {
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
        hasRunOnPlaceFunc = false
    }

    func skipPlayers(_ count: Int) {
        engine.skipPlayers(count)
    }
    
    func endAction() {
        hasRunOnPlaceFunc = false
        withAnimation(.easeOut(duration: 0.25)) {
            engine.activeCardUI = nil
        }
    }
    
    func getCardSelectorInput(function: @escaping (Int) -> Void) {
        engine.bindCardSelectorInput(function: function)
    }

    func endTurn() {
        hasRunOnPlaceFunc = false
        engine.endTurn()
    }

    func nextPlayer() {
        engine.nextPlayer()
    }

    func reverseDirection() {
        if engine.direction == .Clockwise {
            engine.direction = .CounterClockwise
        } else {
            engine.direction = .Clockwise
        }
    }

    func drawCards(indexOffset: Int = 1, _ count: Int, reason: UnoDrawReason) {
        engine.drawCards(
            indexOffset: indexOffset,
            count,
            reason: reason
        )
    }
}
