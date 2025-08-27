//
//  UnoCardBackside.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 28.07.25.
//

import Foundation
import SwiftUICore

class UnoCardBackside2: UnoCard {
    internal var id = UUID()
    var colorIndex: Int
    
    init(colorIndex: Int = -2) {
        self.colorIndex = colorIndex
    }
    
    func hasSpecialPlaceUI() -> Bool { false }
    func getOnPlaceUI(actions: UnoCardActionHandler) -> any View {
        let _ = actions.runOnPlace { print("SHOULDN'T BE POSSIBLE") }
        return Text("")
    }
    
    func getOnPlaceTwoPlayersUI(actions: UnoCardTwoPlayerActionHandler) -> any View {
        let _ = actions.runOnPlace { print("SHOULDN'T BE POSSIBLE") }
        return Text("")
    }
    
    func canBePlacedOn(_ card: any UnoCard) -> Bool {
        return false
    }
    
    func getImageName() -> String {
        return ""
    }
    
    func getChar() -> String {
        "UNO"
    }
    
    func getColorIndex() -> Int { colorIndex }
    
    func getSortingValue() -> Double { 0 }
    
    func setColorIndex(_ index: Int) {}
    
    func getTypeName() -> String {
        return "UFALEJHBGNFAILWNJFKDCHMAWPIFU HAFHIUPAELHF BJNCASD"
    }
    
    func getSaveString() -> String {
        return "\(getTypeName()):fuOLHAWFUIALWKFHJAWFasöglkjM"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UnoCardBackside2, rhs: UnoCardBackside2) -> Bool {
        return lhs.id == rhs.id
    }
}
