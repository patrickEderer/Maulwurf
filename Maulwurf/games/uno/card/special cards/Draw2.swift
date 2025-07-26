//
//  draw_2.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 26.07.25.
//

import Foundation

class Draw2: UnoCard, SpecialUnoCard {
    override func isSpecialCard() -> Bool { true }
    
    override init(color: UnoCardColor, char: String) {
        super.init(color: color, char: "+2")
    }
    
    func onPlace(actions: UnoCardActionHandler) {
        actions.nextPlayer()
        actions.drawCards(DrawConditions(count: 2, canPlace2OnTop: true))
    }
    
    func onPlaceTwoPlayers(actions: UnoCardTwoPlayerActionHandler) {
        actions.otherPlayer()
        actions.drawCards(DrawConditions(count: 2, canPlace2OnTop: true))
    }
    
    override func canBePlacedOn(_ card: UnoCard) -> Bool {
        super.canBePlacedOn(card)
    }
}
