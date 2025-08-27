//
//  draw_2.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 26.07.25.
//

import Foundation
import SwiftUI

class Reverse: UnoCard {
    private var colorIndex: Int
    internal var id = UUID()
    
    init(colorIndex: Int) {
        self.colorIndex = colorIndex
    }
    
    func hasSpecialPlaceUI() -> Bool { false }
    func getOnPlaceUI(actions: UnoCardActionHandler) -> any View {
        let _ = actions.runOnPlace {
            actions.reverseDirection()
            actions.nextPlayer()
            actions.endTurn()
        }
        return Text("")
    }
    
    func getOnPlaceTwoPlayersUI(actions: UnoCardTwoPlayerActionHandler) -> any View {
        let _ = actions.runOnPlace {
            actions.engine.unlock()
            actions.endTurn(nextPlayer: false)
        }
        return Text("")
    }
    
    func canBePlacedOn(_ card: any UnoCard) -> Bool {
        if getColorIndex() == card.getColorIndex() { return true }
        if card.getChar() == "⇄" { return true }
        
        return false
    }
    
    func getChar() -> String { "⇄" }
    
    func getColorIndex() -> Int { colorIndex }
    
    func getImageName() -> String { "uno.card.action.reverse" }
    
    func getSortingValue() -> Double { 13 + (Double(colorIndex) * 0.1) }
    
    func setColorIndex(_ index: Int) {}
    
    func getTypeName() -> String {
        return "Reverse"
    }
    
    func getSaveString() -> String {
        return "\(getTypeName()):\(colorIndex)"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Reverse, rhs: Reverse) -> Bool {
        lhs.id == rhs.id
    }
}
