//
//  draw_2.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 26.07.25.
//

import Foundation
import SwiftUICore

class Draw4: UnoCard {
    var colorIndex = -1
    internal var id = UUID()
    
    init(colorIndex: Int = -1) {
        self.colorIndex = colorIndex
    }
    
    func hasSpecialPlaceUI() -> Bool { true }
    func getOnPlaceUI(actions: UnoCardActionHandler) -> any View {
        actions.runOnPlace {
            actions.saveVar(key: "draw_count", val: "4")
        }
        
        return VStack {
            @State var hasSelectedColor = false
            if !hasSelectedColor {
                AnyView(
                    UnoPresetActionUIs.getInstance().getPickColorUI(engine: actions.engine) { i in
                        actions.engine.modifyTopCard { card in
                            card.setColorIndex(i)
                        }
                        hasSelectedColor = true
                        actions.skipPlayers(1)
                        actions.nextPlayer()
                    }
                )
            } else {
                AnyView(
                    UnoPresetActionUIs.getInstance().getDrawCardUI(cardChar: "+4") { _ in
                        actions.skipPlayers(1)
                        actions.nextPlayer()
                        actions.saveVar(key: "draw_count", val: "\(Int(actions.getSaveVar(key: "draw_count"))! + 4)")
                    } onDraw: {
                        actions.drawCards(indexOffset: 0, Int(actions.getSaveVar(key: "draw_count"))!, reason: .DRAW_2)
                        actions.endAction()
                    } currentCountFunc: {
                        actions.getSaveVar(key: "draw_count")
                    }
                )
            }
        }
    }
    
    func getOnPlaceTwoPlayersUI(actions: UnoCardTwoPlayerActionHandler) -> any View {
        let _ = actions.runOnPlace {actions.drawCards(4, reason: .DRAW_4)}
        return UnoPresetActionUIs.getInstance().getPickColorUI(engine: actions.engine) { i in
            actions.engine.modifyTopCard { card in
                card.setColorIndex(i)
            }
            actions.otherPlayer()
            actions.endTurn()
        }
    }
    
    func canBePlacedOn(_ card: any UnoCard) -> Bool { true }
    
    func getImageName() -> String { "uno.card.wild.+4" }
    
    func getChar() -> String { "+4" }
    
    func getColorIndex() -> Int { colorIndex }
    
    func getSortingValue() -> Double { 12 }
    
    func setColorIndex(_ index: Int) {
        colorIndex = index
    }
    
    func getTypeName() -> String {
        return "Draw4"
    }
    
    func getSaveString() -> String {
        return "\(getTypeName()):\(colorIndex)"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Draw4, rhs: Draw4) -> Bool {
        return lhs.id == rhs.id
    }
}
