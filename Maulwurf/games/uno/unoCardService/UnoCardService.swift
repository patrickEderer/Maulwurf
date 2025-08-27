//
//  UnoCardService.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 11.08.25.
//

import Foundation

class UnoCardService: ObservableObject {
    private static var INSTANCE: UnoCardService?
    private var deck: [any UnoCard] = []
    @Published private var includedSpecialCards: [SpecialUnoCardTypes] = SpecialUnoCardTypes.allCases
    var unoColorManager = UnoColorManager.getInstance()

    private init() {
    }

    public static func getInstance() -> UnoCardService {
        if INSTANCE == nil {
            INSTANCE = UnoCardService()
        }
        return INSTANCE!
    }
    
    func genRandomNumberCard() -> any UnoCard {
        let card = UnoNumberCard(colorIndex: Int.random(in: 0..<unoColorManager.getColorCount()), number: Int.random(in: 0..<10))
        return card
    }
    
    func getIncludedSpecialCards() -> [SpecialUnoCardTypes] {
        return includedSpecialCards
    }
    
    func toggleSpecialCard(_ type: SpecialUnoCardTypes) {
        if includedSpecialCards.contains(type) {
            includedSpecialCards.removeAll { $0 == type }
        } else {
            includedSpecialCards.append(type)
        }
    }

    public func initDeck() {
        deck = []
        for _ in 0..<2 {
            for color in 0..<unoColorManager.getColorCount() {
                //Numbers
                for number in 0..<10 {
                    deck.append(
                        UnoNumberCard(colorIndex: color, number: number)
                    )
                }
                
                //+2
                if includedSpecialCards.contains(.DRAW_2) { deck.append(Draw2(colorIndex: color)) }
                
                //reverse
                if includedSpecialCards.contains(.REVERSE) { deck.append(Reverse(colorIndex: color)) }
                
                //skip
                if includedSpecialCards.contains(.SKIP) { deck.append(Skip(colorIndex: color)) }
            }
            
            for _ in 0..<4 {
                //Wild
                if includedSpecialCards.contains(.WILD) { deck.append(Wild()) }
                
                //+4
                if includedSpecialCards.contains(.DRAW_4) { deck.append(Draw4()) }
            }
        }
        shuffleDeck()
    }

    private func shuffleDeck() {
        deck.shuffle()
    }

    func drawCard() -> any UnoCard {
        if deck.count <= 10 {
            initDeck()
        }
        return deck.removeFirst()
    }
}
