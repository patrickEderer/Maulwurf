//
//  SpecialUnoCard.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 26.07.25.
//

import Foundation

protocol SpecialUnoCard: UnoCard {
    func onPlace(actions: UnoCardActionHandler)
    func onPlaceTwoPlayers(actions: UnoCardTwoPlayerActionHandler)
    func canBePlacedOn(_ card: UnoCard) -> Bool
}
