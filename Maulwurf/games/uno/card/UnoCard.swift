//
//  SpecialUnoCard.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 26.07.25.
//

import Foundation
import SwiftUICore

protocol UnoCard: Hashable {
    var id: UUID { get }
    func hasSpecialPlaceUI() -> Bool
    func getOnPlaceUI(actions: UnoCardActionHandler) -> any View
    func getOnPlaceTwoPlayersUI(actions: UnoCardTwoPlayerActionHandler) -> any View
    func canBePlacedOn(_ card: any UnoCard) -> Bool
    func getImageName() -> String
    func getChar() -> String
    func getColorIndex() -> Int
    func getSortingValue() -> Double
    func setColorIndex(_ index: Int)
    func getSaveString() -> String
}
