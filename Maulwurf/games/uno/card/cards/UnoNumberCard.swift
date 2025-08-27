//
//  UnoCard.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 14.07.25.
//

import Foundation
import SwiftUICore

class UnoNumberCard: UnoCard {
    internal var id = UUID()
    
    private var colorIndex: Int
    private var number: Int

    init(colorIndex: Int, number: Int) {
        self.colorIndex = colorIndex
        self.number = number
    }
    
    func hasSpecialPlaceUI() -> Bool { false }
    func getOnPlaceUI(actions: UnoCardActionHandler) -> any View {
        let _ = actions.runOnPlace {
            actions.nextPlayer()
            actions.endTurn()
        }
        return Text("")
    }
    
    func getOnPlaceTwoPlayersUI(actions: UnoCardTwoPlayerActionHandler) -> any View {
        let _ = actions.runOnPlace {
            actions.otherPlayer()
            actions.endTurn()
        }
        return Text("")
    }
    
    func getImageName() -> String {
        "uno.card.number.\(number)"
    }
    
    public func canBePlacedOn(_ card: any UnoCard) -> Bool {
        if getColorIndex() == card.getColorIndex() { return true }
        if getChar() == card.getChar() { return true }
        
        return false
    }
    
    func getChar() -> String {
        return "\(number)"
    }
    
    func getColorIndex() -> Int { colorIndex }
    
    func getSortingValue() -> Double { Double(number) + (Double(colorIndex) * 0.1) }
    
    func setColorIndex(_ index: Int) {
        colorIndex = index
    }
    
    func getTypeName() -> String {
        return "Number"
    }
    
    func getSaveString() -> String {
        return "\(getTypeName()):\(colorIndex):\(number)"
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: UnoNumberCard, rhs: UnoNumberCard) -> Bool {
        return lhs.id == rhs.id
    }
}
