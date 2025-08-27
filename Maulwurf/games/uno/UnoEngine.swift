//
//  UnoEngine.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 22.07.25.
//

import Foundation
import SwiftUICore

class UnoEngine: ObservableObject {
    var server: LocalUnoServer = LocalUnoServer.getInstance()
    var updater = Updater.getInstance()
    var cardActions: UnoCardActionHandler? = nil
    var twoPlacerCardActions: UnoCardTwoPlayerActionHandler? = nil
    
    var saveQueue: SaveQueue = SaveQueue.getInstance()
    var fileSaver = FileSaver.getInstance()
    var deck = UnoCardService.getInstance()
    
    @Published var isRunning = false
    @Published var sortingAnimation = false
    
    @Published var direction: UnoDirection = .Clockwise
    @Published var currentPlayerIndex: Int = 0
    @Published var cardHistory: [(any UnoCard, Int)]
    @Published var isLocked = true
    @Published var waitingForPlayer: Bool = false
    @Published var showCardSelectorHighlighted: Bool = false
    @Published var userInputDisabled: Bool = false
    @Published var startingCardsCount = 7
    
    @Published var players: [UnoPlayer] = []
    @Published var activeCardUI: (any View)? = nil
    @Published var playerHasDrawn = false
    @Published var unoButtonPressed: Bool = false
    
    @Published var drawCardQueueData: (any UnoCard, UnoDrawCardAnimPos, UnoDrawReason)? = nil
    @Published var pulse = false
    var drawQueueRunning = false
    var cardSelectorInputRedirect: ((Int) -> Void)?
    
    private static var INSTANCE: UnoEngine?
    
    private init() {
        cardHistory = []
        cardActions = UnoCardActionHandler(engine: self)
        twoPlacerCardActions = UnoCardTwoPlayerActionHandler(engine: self)
        startPulseAnimation()
        
        readFileOrSetDefault()
        
        startServer()
    }
    
    public static func getInstance() -> UnoEngine {
        if (INSTANCE == nil) {
            INSTANCE = UnoEngine()
        }
        return INSTANCE!
    }
    
    func startServer() {
        server.start(UnoNumberCard(colorIndex: -1, number: -10))
    }
    
    func stop() {
        isRunning = false
        sortingAnimation = false
        direction = .Clockwise
        currentPlayerIndex = 0
        cardHistory = []
        isLocked = true
        waitingForPlayer = false
        showCardSelectorHighlighted = false
        userInputDisabled = false
        activeCardUI = nil
        cardSelectorInputRedirect = nil
        playerHasDrawn = false
        unoButtonPressed = false
        drawCardQueueData = nil
        pulse = false
        
        cardActions = UnoCardActionHandler(engine: self)
        twoPlacerCardActions = UnoCardTwoPlayerActionHandler(engine: self)
        
        startServer()
    }
    
    func reset() {
        direction = .Clockwise
        currentPlayerIndex = 0
        cardHistory = []
    }
    
    func start() {
        deck.initDeck()
        cardHistory.append((deck.genRandomNumberCard(), -1))
        for player in players {
            if !player.isPlaying {
                player.cards = []
                continue
            }
            player.cards = (0..<startingCardsCount).map { _ in deck.drawCard() }
        }
        isRunning = true
        Thread {
            while self.getRemainingPlayers().count > 1 {
                Thread.sleep(forTimeInterval: 1)
            }
        }.start()
    }
    
    func modifyTopCard(_ modifier: @escaping (any UnoCard) -> Void) {
        modifier(getTopCard())
    }
    
    func drawCards(indexOffset: Int, _ count: Int, reason: UnoDrawReason) {
        for _ in 0..<count {
            getRemainingPlayers()[getIndexOfPlayer(indexOffset: indexOffset)].drawQueue.append((deck.drawCard(), reason))
        }
        if indexOffset == 0 {
            Thread {
                self.checkAndShowDrawQueue()
            }.start()
        }
    }
    
    func addPlayer(player: UnoPlayer) {
        players.append(player)
        savePlayers()
    }
    
    func removePlayer(_ index: Int) {
        players.remove(at: index)
        savePlayers()
    }
    
    public func savePlayers() {
        print("Saving Players...")
        saveQueue.createIfAbsentQueue(
            queue: SaveQueue.Queue(
                key: .UNO_Players,
                delay: 1,
                valueFunc: {
                    return self.players.map {
                        $0.toString()
                    }.joined(separator: "#")
                }
            )
        )
    }
    
    func getRemainingPlayers() -> [UnoPlayer] {
        return players.filter { player in !player.cards.isEmpty }
    }
    
    func placeCard(_ cardIndex: Int) {
        let card = getRemainingPlayers()[currentPlayerIndex].cards[cardIndex]
        if card.getChar() == "UNO" { return }
        playerHasDrawn = false
        
        if !canPlaceCard(card) {
            print("ERROR: TRIED PLACING CARD THAT CAN'T BE PLACED")
            return
        }
        
        showCardSelectorHighlighted = false
        
        cardHistory.append((card, currentPlayerIndex))
        getRemainingPlayers()[currentPlayerIndex].cards.remove(at: cardIndex)
        checkAndRunCardAction(card)
        server.setTopCard(card)
        
        currentPlayerIndex %= getRemainingPlayers().count
        
        if getRemainingPlayers()[currentPlayerIndex].autoSort {
            self.sortCards(playerIndex: self.currentPlayerIndex)
        }
    }
    
    func getPlayer(index: Int) -> UnoPlayer {
        let remainingPlayers = getRemainingPlayers()
        if index >= remainingPlayers.count {
            print("ERROR: INDEX OUT OF BOUNDS FOR PLAYERS - \(index) > \(remainingPlayers)")
        }
        return remainingPlayers[index]
    }
    
    private func saveGame() {
        let fileManager = FileManager.default
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        var saveFileURL = documentDirectory.appendingPathComponent("uno_game_save_players.txt")
        try! "\(getGameSavePlayersString())".write(to: saveFileURL, atomically: true, encoding: .utf8)
        saveFileURL = documentDirectory.appendingPathComponent("uno_game_save_card-history.txt")
        try! "\(getGameSaveCardHistoryString())".write(to: saveFileURL, atomically: true, encoding: .utf8)
    }
    
    private func getGameSavePlayersString() -> String {
        var res = ""
        res.append("\(currentPlayerIndex)#")
        print(currentPlayerIndex)
        for player in players {
            res.append("\(player.name);\(player.autoSort),")
            res.append(player.cards.map { card in card.getSaveString() }.joined(separator: ";"))
            res.append("&")
        }
        return res
    }
    
    private func getGameSaveCardHistoryString() -> String {
        var res = ""
        for i in 0..<cardHistory.count {
            let card = cardHistory[i]
            res.append("\(card.0.getSaveString())-\(card.1)")
            
            if i < cardHistory.count - 1 {
                res.append(";")
            }
        }
        return res
    }
    
    public func readOldGameSave() {
        do {
            let fileManager = FileManager.default
            let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            var saveFileURL = documentDirectory.appendingPathComponent("uno_game_save_players.txt")
            readOldGameSavePlayersFromString(try String(contentsOf: saveFileURL, encoding: .utf8))
            
            saveFileURL = documentDirectory.appendingPathComponent("uno_game_save_card-history.txt")
            readOldGameSaveCardHistoryFromString(try String(contentsOf: saveFileURL, encoding: .utf8))
        } catch {
            print("Error reading save data :( \(error)")
        }
    }
    
    private func readOldGameSavePlayersFromString(_ readStr: String) {
        let splitStr = readStr.split(separator: "#")
        currentPlayerIndex = Int(splitStr[0]) ?? 0
        print(currentPlayerIndex, splitStr)
        
        let splitPlayersStr = splitStr[1].split(separator: "&")
        for playerStr in splitPlayersStr {
            let splitPlayerStr = playerStr.split(separator: ",")
            let splitPlayerPlayerStr = splitPlayerStr[0].split(separator: ";")
            let player = players.filter { player in
                player.name == splitPlayerPlayerStr[0]
            }.first!
            player.autoSort = splitPlayerPlayerStr[1] == "true"
            
            let splitCardsStr = splitPlayerStr[1].split(separator: ";")
            
            var cards: [any UnoCard] = []
            for cardStr in splitCardsStr {
                let splitCardStr = cardStr.split(separator: ":")
                let cardType = splitCardStr[0]
                switch cardType {
                case "Draw2": cards.append(Draw2(colorIndex: Int(splitCardStr[1])!))
                case "Draw4": cards.append(Draw4())
                case "Reverse": cards.append(Reverse(colorIndex: Int(splitCardStr[1])!))
                case "Skip": cards.append(Skip(colorIndex: Int(splitCardStr[1])!))
                case "Number": cards.append(UnoNumberCard(colorIndex: Int(splitCardStr[1])!, number: Int(splitCardStr[2])!))
                case "Wild": cards.append(Wild())
                default: print("FHPIAUOWEIÖFGHAPWJOIFA;XAMP IPHCWAMIHFUAIWUFGHGIUSAUEGI")
                }
            }
            player.cards = cards
        }
    }
    
    private func readOldGameSaveCardHistoryFromString(_ readStr: String) {
        let cardStrArr = readStr.split(separator: ";")
        cardHistory = []
        for cardWithPlacerStr in cardStrArr {
            let splitCardWithPlacerStr = cardWithPlacerStr.split(separator: "-")
            let cardStr = splitCardWithPlacerStr[0]
            let placerIndex = Int(splitCardWithPlacerStr[1])!
            
            let splitCardStr = cardStr.split(separator: ":")
            let cardType = splitCardStr[0]
            var card: (any UnoCard)? = nil
            switch cardType {
            case "Draw2": card = Draw2(colorIndex: Int(splitCardStr[1])!)
            case "Draw4": card = Draw4(colorIndex: Int(splitCardStr[1])!)
            case "Reverse": card = Reverse(colorIndex: Int(splitCardStr[1])!)
            case "Skip": card = Skip(colorIndex: Int(splitCardStr[1])!)
            case "Number": card = UnoNumberCard(colorIndex: Int(splitCardStr[1])!, number: Int(splitCardStr[2])!)
            case "Wild": card = Wild(colorIndex: Int(splitCardStr[1])!)
            default: print("IUZGFUTDRUESZDTRUFZIGUHLJKNJBVCDR&TFGHBJNIJ")
            }
            cardHistory.append((card!, placerIndex))
        }
    }
    
    func checkAndRunCardAction(_ card: any UnoCard) {
        withAnimation(.easeOut(duration: 0.25)) {
            if getRemainingPlayers().count != 2 {
                activeCardUI = card.getOnPlaceUI(actions: cardActions!)
            } else {
                activeCardUI = card.getOnPlaceTwoPlayersUI(actions: twoPlacerCardActions!)
            }
        }
    }
    
    func bindCardSelectorInput(function: @escaping (Int) -> Void) {
        cardSelectorInputRedirect = function
    }
    
    func setCardCountCurrentPlayer(_ count: Int) {
        getRemainingPlayers()[currentPlayerIndex].cards = (0..<count).map { _ in deck.drawCard() }
    }
    
    func canPlaceCard(_ card: any UnoCard) -> Bool {
        let topCard = getTopCard()
        
        return card.canBePlacedOn(topCard)
    }
    
    func getTopCard() -> any UnoCard {
        return cardHistory.last?.0 ?? UnoCardBackside()
    }
    
    public func getCurrentPlayer() -> UnoPlayer {
        print("Remaining players", getRemainingPlayers(), currentPlayerIndex)
        return getRemainingPlayers()[currentPlayerIndex]
    }
    
    public func getNextPlayer() -> UnoPlayer {
        return getRemainingPlayers()[getIndexOfPlayer(indexOffset: 1)]
    }
    
    public func getIndexOfPlayer(indexOffset: Int) -> Int {
        let remainingPlayerCount = getRemainingPlayers().count
        
        var index = currentPlayerIndex
        if direction == .Clockwise {
            index += indexOffset
        } else {
            index -= indexOffset
        }
        
        index += remainingPlayerCount
        index %= remainingPlayerCount
        
        return index
    }

    public func nextPlayer() {
        isLocked = true
        playerHasDrawn = false
        
        checkUno()
    }
    
    private func checkUno() {
        if getCurrentPlayer().cards.count == 1 && !unoButtonPressed {
            drawCards(indexOffset: 0, 2, reason: .NO_UNO)
        } else if getCurrentPlayer().cards.count != 1 && unoButtonPressed {
            drawCards(indexOffset: 0, 2, reason: .WRONG_UNO)
        }
        unoButtonPressed = false
    }
    
    func getCardHistory() -> [(any UnoCard, Int)] {
        return cardHistory
    }
    
    func endTurn(nextPlayer: Bool = true) {
        Thread {
            self.checkAndShowDrawQueue()
            
            if nextPlayer {
                DispatchQueue.main.sync {
                    let remainingPlayerCount = self.getRemainingPlayers().count
                    
                    if self.direction == .Clockwise {
                        self.currentPlayerIndex += 1
                    } else {
                        self.currentPlayerIndex -= 1
                    }
                    
                    self.currentPlayerIndex += remainingPlayerCount
                    self.currentPlayerIndex %= remainingPlayerCount
                    
                    self.waitingForPlayer = false
                }
            }
            
            DispatchQueue.main.sync {
                withAnimation(.easeOut(duration: 0.25)) {
                    self.activeCardUI = nil
                    self.cardSelectorInputRedirect = nil
                }
            }
            
            self.saveGame()
        }.start()
    }
    
    func anyPlayerHasUno() -> Bool {
        return !players.allSatisfy { $0.cards.count != 1 }
    }
    
    private func checkAndShowDrawQueue() {
        if drawQueueRunning { return }
        drawQueueRunning = true
        DispatchQueue.main.sync {
            userInputDisabled = true
        }
        let hasToDraw = !getCurrentPlayer().drawQueue.isEmpty
        
        print(getCurrentPlayer().drawQueue)
        
        Thread {
            let debugMul = 1.0
            while !self.getCurrentPlayer().drawQueue.isEmpty {
                DispatchQueue.main.sync {
                    withAnimation(.easeOut(duration: 0.2 * debugMul)) {
                        if !self.getCurrentPlayer().drawQueue.isEmpty {
                            self.getCurrentPlayer().cards.append(self.getCurrentPlayer().drawQueue.first!.0)
                            self.drawCardQueueData = (self.getCurrentPlayer().drawQueue[0].0, .Deck, self.getCurrentPlayer().drawQueue.first!.1)
                            self.drawCardQueueData?.0 = self.getCurrentPlayer().drawQueue[0].0
                            self.drawCardQueueData?.1 = .Deck
                        }
                    }
                }
                Thread.sleep(forTimeInterval: 0.2 * debugMul)
                DispatchQueue.main.sync {
                    withAnimation(.easeOut(duration: 0.2 * debugMul)) {
                        if !self.getCurrentPlayer().drawQueue.isEmpty {
                            self.drawCardQueueData?.1 = .Big
                        }
                    }
                }
                Thread.sleep(forTimeInterval: 0.4 * debugMul)
                DispatchQueue.main.sync {
                    withAnimation(.easeOut(duration: 0.2 * debugMul)) {
                        if !self.getCurrentPlayer().drawQueue.isEmpty {
                            self.getCurrentPlayer().drawQueue.removeFirst()
                            if self.getCurrentPlayer().drawQueue.isEmpty {
                                self.drawCardQueueData = nil
                            }
                        }
                    }
                }
            }
            
            DispatchQueue.main.sync {
                if hasToDraw && self.getRemainingPlayers()[self.currentPlayerIndex].autoSort {
                    Thread.sleep(forTimeInterval: 0.25 * debugMul)
                    self.sortCards(playerIndex: self.currentPlayerIndex)
                }
                self.userInputDisabled = false
                self.drawQueueRunning = false
            }
        }.start()
    }
    
    func skipPlayers(_ count: Int) {
        currentPlayerIndex = getIndexOfPlayer(indexOffset: count)
    }
    
    func sortCards(playerIndex: Int) {
        var cards = self.getRemainingPlayers()[playerIndex].cards
        
        var colorCounts: [Int: Double] = cards.reduce(into: [:]) { counts, card in
            counts[card.getColorIndex(), default: 0] += 1 + (card.getSortingValue() * 0.01)
        }
        colorCounts[-1] = 1000
        
        cards.sort { (card1: UnoCard, card2: UnoCard) -> Bool in
            if colorCounts[card1.getColorIndex()]! != colorCounts[card2.getColorIndex()]! {
                return colorCounts[card1.getColorIndex()]! > colorCounts[card2.getColorIndex()]!
            } else {
                return card1.getSortingValue() > card2.getSortingValue()
            }
        }
        
        if self.getRemainingPlayers()[playerIndex].cards.map({ c in c.getImageName() }) == cards.map({ c in c.getImageName() }) {
            return
        }
        Thread {
            DispatchQueue.main.sync {
                withAnimation(.easeOut(duration: 0.125)) {
                    self.sortingAnimation = true
                }
            }
            Thread.sleep(forTimeInterval: 0.2)
            DispatchQueue.main.sync {
                self.getRemainingPlayers()[playerIndex].cards = cards
                
                withAnimation(.bouncy(duration: 0.25, extraBounce: 0.25)) {
                    self.sortingAnimation = false
                }
            }
        }.start()
    }
    
    func unlock() {
        isLocked = false
        waitingForPlayer = true
        
        Thread {
            self.checkAndShowDrawQueue()
        }.start()
    }
    
    func readFileOrSetDefault() {
        if !fileSaver.containsKey("\(SaveQueueKey.UNO_Players)") {
            setPlayerCount(3)
        } else {
            readPlayers()
        }
    }
    
    private func readPlayers() {
        let readString = fileSaver.read(key: "\(SaveQueueKey.UNO_Players)")
        
        let splitString = readString.split(separator: "#")
        for playerString in splitString {
            players.append(UnoPlayer.fromString(String(playerString), index: players.count))
        }
    }
    
    public func setPlayerCount(_ count: Int) {
        while players.count < count {
            addPlayer(player: UnoPlayer(name: "Player \(players.count + 1)"))
        }
    }
    
    private func startPulseAnimation() {
        Thread {
            while true {
                DispatchQueue.main.sync {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.pulse.toggle()
                    }
                }
                Thread.sleep(forTimeInterval: 0.5)
            }
        }.start()
    }
}

enum UnoDirection {
    case Clockwise
    case CounterClockwise
}
