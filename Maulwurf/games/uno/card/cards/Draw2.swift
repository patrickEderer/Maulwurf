//
//  draw_2.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 26.07.25.
//

import Foundation
import SwiftUI

class Draw2: UnoCard {
    private var colorIndex: Int
    internal var id = UUID()
    
    init(colorIndex: Int) {
        self.colorIndex = colorIndex
    }
    
    func hasSpecialPlaceUI() -> Bool { true }
    func getOnPlaceUI(actions: UnoCardActionHandler) -> any View {
        actions.runOnPlace {
            actions.saveVar(key: "draw_count", val: "2")
            actions.skipPlayers(1)
            actions.nextPlayer()
            actions.getCardSelectorInput(function: { i in print(i) })
        }
        
        return UnoPresetActionUIs.getInstance().getDrawCardUI(cardChar: "+2") { _ in
            actions.skipPlayers(1)
            actions.nextPlayer()
            print(actions.getSaveVar(key: "draw_count"))
            actions.saveVar(key: "draw_count", val: "\(Int(actions.getSaveVar(key: "draw_count"))! + 2)")
        } onDraw: {
            actions.drawCards(indexOffset: 0, Int(actions.getSaveVar(key: "draw_count"))!, reason: .DRAW_2)
            actions.endAction()
        } currentCountFunc: {
            actions.getSaveVar(key: "draw_count")
        }
    }
    
    func getOnPlaceTwoPlayersUI(actions: UnoCardTwoPlayerActionHandler) -> any View {
        actions.runOnPlace {
            actions.saveVar(key: "draw_count", val: "2")
            actions.skipPlayer()
            actions.otherPlayer()
        }
        
        return UnoPresetActionUIs.getInstance().getDrawCardUI(cardChar: "+2") { _ in
            actions.skipPlayer()
            actions.otherPlayer()
            print(actions.getSaveVar(key: "draw_count"))
            actions.saveVar(key: "draw_count", val: "\(Int(actions.getSaveVar(key: "draw_count"))! + 2)")
        } onDraw: {
            actions.drawCards(indexOffset: 0, Int(actions.getSaveVar(key: "draw_count"))!, reason: .DRAW_2)
            actions.endAction()
        } currentCountFunc: {
            actions.getSaveVar(key: "draw_count")
        }
    }
    
    func canBePlacedOn(_ card: any UnoCard) -> Bool {
        if getColorIndex() == card.getColorIndex() { return true }
        if card.getChar() == "+2" { return true }
        
        return false
    }
    
    func getChar() -> String { "+2" }
    
    func getColorIndex() -> Int { colorIndex }
    
    func getImageName() -> String { "uno.card.action.+2" }
    
    func getSortingValue() -> Double { 10 + (Double(colorIndex) * 0.1) }
    
    func setColorIndex(_ index: Int) {}
    
    func getTypeName() -> String {
        return "Draw2"
    }
    
    func getSaveString() -> String {
        return "\(getTypeName()):\(colorIndex)"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Draw2, rhs: Draw2) -> Bool {
        lhs.id == rhs.id
    }
}

#Preview {
    let engine = UnoEngine.getInstance()
    let _ = engine.start()
    UnoView(engine: engine)
    let _ = engine.isLocked = false
    let _ = engine.activeCardUI = Draw2(colorIndex: 0).getOnPlaceUI(actions: UnoCardActionHandler(engine: engine))
}
