//
//  UnoCardBackside.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 28.07.25.
//

import Foundation
import SwiftUICore

class UnoCardBackside: UnoCard {
    internal var id = UUID()
    
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
        return "uno.card.backside"
    }
    
    func getChar() -> String {
        "UNO"
    }
    
    func getColorIndex() -> Int { -2 }
    
    func getSortingValue() -> Double { 0 }
    
    func setColorIndex(_ index: Int) {}
    
    func getTypeName() -> String {
        print("FBPAIUFHAWPFGIUOALMKWH;XRFPIAUWHF AIPUW FHIAOFLHAWIL UKFHAWOFUHWFLKUH")
        return ""
    }
    
    func getSaveString() -> String {
        return "\(getTypeName()):vUIWHLFAPIWFOUKALWHMF;PLkhfgiuoalmkwech,fa"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UnoCardBackside, rhs: UnoCardBackside) -> Bool {
        return lhs.id == rhs.id
    }
}
