//
//  UnoEngine.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 22.07.25.
//

import Foundation

class UnoEngine: ObservableObject {
    var server: LocalUnoServer = LocalUnoServer.getInstance()
    var updater = Updater.getInstance()
    var cardActions: UnoCardActionHandler? = nil
    var twoPlacerCardActions: UnoCardTwoPlayerActionHandler? = nil
    
    @Published var direction: UnoDirection = .Clockwise
    @Published var currentPlayerIndex: Int = 0
    @Published var cardHistory: [UnoCard] = [UnoCard.genRandom()]
    
    var waitingForPlayer: Bool = false
    
    @Published var players: [UnoPlayer] = (0..<5).map { UnoPlayer(name: "Player \($0 + 1)") }
    
    private static var INSTANCE: UnoEngine?
    
    private init() {
        cardActions = UnoCardActionHandler(engine: self)
        twoPlacerCardActions = UnoCardTwoPlayerActionHandler(engine: self)
        
        startServer()
    }
    
    public static func getInstance() -> UnoEngine {
        if (INSTANCE == nil) {
            INSTANCE = UnoEngine()
        }
        return INSTANCE!
    }
    
    func startServer() {
        server.start(getTopCard())
    }
    
    func reset() {
        direction = .Clockwise
        currentPlayerIndex = 0
        cardHistory = []
    }
    
    func start() {
        Thread {
            while self.remainingPlayers().count > 1 {
                self.waitingForPlayer = true
                while self.waitingForPlayer {
                    Thread.sleep(forTimeInterval: 0.5)
                }
                self.nextPlayer()
            }
        }.start()
    }
    
    func placeCard(_ cardIndex: Int) {
        let card = players[currentPlayerIndex].cards[cardIndex]
        
        if canPlaceCard(card) {
            cardHistory.append(card)
            players[currentPlayerIndex].cards.remove(at: cardIndex)
            checkAndRunCardAction(card)
            waitingForPlayer = false
            server.setTopCard(card)
        } else {
            print("ERROR: TRIED PLACING CARD THAT CAN'T BE PLACED")
        }
    }
    
    func checkAndRunCardAction(_ card: UnoCard) {
        if card.isSpecialCard() {
            print("IS SPECIAL")
            let specialCard = card as! SpecialUnoCard
            
            if remainingPlayers().count != 2 {
                specialCard.onPlace(actions: cardActions!)
            } else {
                specialCard.onPlaceTwoPlayers(actions: twoPlacerCardActions!)
            }
        }
    }
    
    func setCardCountEveryPlayer(_ count: Int) {
        players[currentPlayerIndex].cards = (0..<count).map { _ in UnoCard.genRandom() }
    }
    
    func canPlaceCard(_ card: UnoCard) -> Bool {
        let topCard = getTopCard()
        
        return card.canBePlacedOn(topCard)
    }
    
    func getTopCard() -> UnoCard {
        return cardHistory.last!
    }
    
    public func getCurrentPlayer() -> UnoPlayer {
        return players[currentPlayerIndex]
    }
    
    public func getNextPlayer() -> UnoPlayer {
        nextPlayer()
        return players[currentPlayerIndex]
    }

    public func nextPlayer() {
        let remainingPlayerCount = remainingPlayers().count
        
        if direction == .Clockwise {
            currentPlayerIndex += 1
        } else {
            currentPlayerIndex -= 1
        }
        
        currentPlayerIndex += remainingPlayerCount
        currentPlayerIndex %= remainingPlayerCount
    }
    
    private func remainingPlayers() -> [UnoPlayer] {
        return players.filter { $0.cards.count > 0 }
    }
    
    func sortCards(playerIndex: Int) {
        var cards = players[playerIndex].cards
        
        let colorCounts: [UnoCardColor: Int] = cards.reduce(into: [:]) { counts, card in
            counts[card.color, default: 0] += 1
        }
        
        cards.sort { (card1, card2) -> Bool in
            return colorCounts[card1.color, default: 0] > colorCounts[card2.color, default: 0]
        }
        
        players[playerIndex].cards = cards
        
        updater.update()
    }
}

enum UnoDirection {
    case Clockwise
    case CounterClockwise
}
