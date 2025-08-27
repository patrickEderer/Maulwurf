//
//  draw_2.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 26.07.25.
//

import Foundation
import SwiftUICore

class Wild: UnoCard {
    var colorIndex = -1
    internal var id = UUID()
    
    init(colorIndex: Int = -1) {
        self.colorIndex = colorIndex
    }
    
    func hasSpecialPlaceUI() -> Bool { true }
    func getOnPlaceUI(actions: UnoCardActionHandler) -> any View {
        UnoPresetActionUIs.getInstance().getPickColorUI(engine: actions.engine) { i in
            actions.engine.modifyTopCard { card in
                card.setColorIndex(i)
            }
            actions.nextPlayer()
            actions.endTurn()
        }
    }
    
    func getOnPlaceTwoPlayersUI(actions: UnoCardTwoPlayerActionHandler) -> any View {
        UnoPresetActionUIs.getInstance().getPickColorUI(engine: actions.engine) { i in
            actions.engine.modifyTopCard { card in
                card.setColorIndex(i)
            }
            actions.otherPlayer()
            actions.endTurn()
        }
    }
    
    func canBePlacedOn(_ card: any UnoCard) -> Bool { true }
    
    func getImageName() -> String { "uno.card.wild.color_pick" }
    
    func getChar() -> String { "WILD" }
    
    func getColorIndex() -> Int { colorIndex }
    
    func getSortingValue() -> Double { 11 }
    
    func setColorIndex(_ index: Int) {
        colorIndex = index
    }
    
    func getTypeName() -> String {
        return "Wild"
    }
    
    func getSaveString() -> String {
        return "\(getTypeName()):\(colorIndex)"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Wild, rhs: Wild) -> Bool {
        return lhs.id == rhs.id
    }
}
