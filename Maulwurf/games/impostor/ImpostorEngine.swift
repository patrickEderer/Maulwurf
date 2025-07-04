//
//  Engine.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 01.06.25.
//

import Foundation

public class ImpostorEngine: ObservableObject {
    var fileSaver = FileSaver.getInstance()
    @Published var updater = Updater.getInstance()
    @Published var gameState: ImpostorGameState = .Settings
    @Published var names: [String] = []
    
    var players: [ImpostorPlayer] = []
    var gameMode: ImpostorGameMode = .Normal
    var startingPlayerIndex = 0
    var showHint = false
    var words: [String] = []
    
    var gameModePercentages: [ImpostorGameMode: Double] = [:]
    
    var currentShowingCardIndex = 0
    
    var showingSingleCard: Bool = false
    
    init() {
        fileSaver.saveIfAbsent(key: "impostor:nameCount", value: "3")
        fileSaver.saveIfAbsent(key: "impostor:names", value: "=")
        let nameCountStr = fileSaver.read(key: "impostor:nameCount")
        let nameStr = fileSaver.read(key: "impostor:names")
        
        names = nameStr.split(separator: "=").map { String($0) }
        
        setPlayerCount(Int(nameCountStr)!)
        
        gameModePercentages[.MultipleImpostors] = Double(fileSaver.read(key: "impostor:gameModes:multipleImpostors")) ?? 0
        gameModePercentages[.MultipleWords] = Double(fileSaver.read(key: "impostor:gameModes:multipleWords")) ?? 0
        gameModePercentages[.NoImpostors] = Double(fileSaver.read(key: "impostor:gameModes:noImpostors")) ?? 0
        
        showHint = fileSaver.read(key: "impostor:showHint") == "true"
    }
    
    func startGame() {
        DropDownOpenManager.getInstance().closeAll()
        
        showingSingleCard = false
        
        randomGameMode()
        let impostors: [Int] = pickRandomImpostors()
        let words = genRandomWords()
        self.words = words.map(\.0)
        players = []
        let indexRemapper = IndexRemapper(length: names.count)
        for i in 0..<names.count {
            let randomIndex = indexRemapper.getIndex(index: Int.random(in: 0..<indexRemapper.getRemainingLength()))
            let isImpostor = impostors.contains(i)
            players.append(ImpostorPlayer(name: names[i].isEmpty ? "Player \(i + 1)" : names[i], isImpostor: isImpostor, word: isImpostor ? words[0].1[Int.random(in: 0..<words[0].1.count)] : words[randomIndex % words.count].0))
        }
        
        startingPlayerIndex = Int.random(in: 0..<players.count)
        
        self.gameState = .ShowingCards
        currentShowingCardIndex = -1
        showNextCard()
    }
    
    public func saveAll() {
        fileSaver.save(key: "impostor:nameCount", value: "\(names.count)")
        fileSaver.save(key: "impostor:names", value: "\(names.joined(separator: "="))")
        
        fileSaver.save(key: "impostor:gameModes:multipleImpostors", value: "\(gameModePercentages[.MultipleImpostors] ?? 0)")
        fileSaver.save(key: "impostor:gameModes:multipleWords", value: "\(gameModePercentages[.MultipleWords] ?? 0)")
        fileSaver.save(key: "impostor:gameModes:noImpostors", value: "\(gameModePercentages[.NoImpostors] ?? 0)")
        
        fileSaver.save(key: "impostor:showHint", value: "\(showHint)")
    }
    
    public func setGameModePercentages(gameModePercentages: [ImpostorGameMode: Double]) {
        self.gameModePercentages = gameModePercentages
    }
    
    public func setPlayerCount(_ count: Int) {
        updateNameLenght(count)
    }
    
    private func updateNameLenght(_ length: Int) {
        let newNames = (0..<length).map { i in
            names.count < i + 1 ? "" : names[i]
        }
        
        names = newNames
    }
    
    func genRandomWords() -> [(String, [String])] {
        if gameMode == .MultipleWords {
            return [
                Words.getInstance().getRandom(),
                Words.getInstance().getRandom()
            ]
        } else {
            return [
                Words.getInstance().getRandom()
            ]
        }
    }
    
    func pickRandomImpostors() -> [Int] {
        print(gameMode)
        var impostorCount: Int
        switch gameMode {
        case .Normal:
            impostorCount = 1
        case .MultipleImpostors:
            impostorCount = Int.random(in: 2...names.count)
        case .NoImpostors, .MultipleWords:
            return []
        }
        
        var impostors: [Int] = []
        let indexRemapper = IndexRemapper(length: names.count)
        for _ in 0..<impostorCount {
            let rng = Int.random(in: 0..<indexRemapper.getRemainingLength())
            impostors.append(indexRemapper.getIndex(index: rng))
        }
        
        return impostors
    }
    
    func randomGameMode() {
        self.gameMode = ImpostorGameMode.genRandom(gameModePercentages: gameModePercentages)
    }
    
    func showNextCard() {
        currentShowingCardIndex += 1
        showCard(forIndex: currentShowingCardIndex)
    }
    
    func showCard(forIndex i: Int) {
        currentShowingCardIndex = i
        self.gameState = .ShowingCards
    }
    
    func showSingleCard(forIndex i: Int) {
        currentShowingCardIndex = i
        self.gameState = .ShowingCards
        showingSingleCard = true
    }
}
