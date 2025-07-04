//
//  Engine.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 23.06.25.
//

import Foundation

public class WerwolfEngine: ObservableObject {
    var saveQueue = SaveQueue.getInstance()
    var fileSaver = FileSaver.getInstance()
    var sensoryFeedback = SensoryFeedback.getInstance()
    @Published private var players: [WerwolfPlayer] = []
    @Published private var roles: [WerwolfRole: Int] = [:]
    @Published var errors: [WerwolfErrors] = []
    
    @Published var gameState: WerwolfGameState = .Uninitialized
    
    @Published var showingRoleUI: WerwolfRole? = nil
    @Published var dayNight: WerwolfDayNight = .Night
    
    @Published var roleUIScreenState: WerwolfRoleUIScreenState = .Locked
    
    @Published var result: WerwolfEndCondition?
    
    var witchPotions: (Bool, Bool) = (true, true)
    var roleActions: WerwolfRoleActions?
    
    init() {
        readFileOrSetDefault()
        
//        start()
//        startGame()
    }
    
    func start() {
        roleActions = WerwolfRoleActions(engine: self)
        
        if !checkStartConditions() {
            return
        }
        
        gameState = .ShowingRoles
        
        assertRoles()
    }
    
    func startGame() {
        gameState = .Running
        
        Thread {
            self.checkAndShowRoleUI(role: .Armor)
            while self.gameState == .Running {
                if self.checkWinCondition() {
                    return
                }
                
                self.showRoleUIs()
                
                DispatchQueue.main.sync {
                    self.dayNight = .Day
                }
                
                while self.dayNight == .Day {
                    Thread.sleep(forTimeInterval: 0.2)
                }
            }
        }.start()
    }
    
    private func showRoleUIs() {
        checkAndShowRoleUI(role: .Werwolf)
        
        checkAndShowRoleUI(role: .Hexe)
        
        checkAndShowRoleUI(role: .Seherin)
    }
    
    private func checkAndShowRoleUI(role: WerwolfRole) {
        if !players.reduce(true, { r, p in
            r && p.role != role
        }) {
            showRoleUIAndWaitUntilDone(role: role)
        }
    }
    
    private func showRoleUIAndWaitUntilDone(role: WerwolfRole) {
        self.showRoleUI(for: role)
        while self.showingRoleUI != nil {
            Thread.sleep(forTimeInterval: 0.2)
        }
    }
    
    private func showRoleUI(for role: WerwolfRole) {
        DispatchQueue.main.sync {
            roleUIScreenState = .Locked
            showingRoleUI = role
        }
        Thread {
            for _ in 0..<5 {
                self.sensoryFeedback.playVibrationSound()
                Thread.sleep(forTimeInterval: 0.75)
            }
        }.start()
    }
    
    private func checkWinCondition() -> Bool {
        let werwolfes = players.reduce(into: 0) { result, player in
            if player.role == .Werwolf {
                result += 1
            }
        }
        let nonWerwolfes = players.count - werwolfes
        
        if werwolfes >= nonWerwolfes {
            DispatchQueue.main.sync {
                stop(reason: .WerwolfsWon)
            }
            return true
        }
        return false
    }
    
    private func assertRoles() {
        let roleList = createRoleList()
        let indexRemapper = IndexRemapper(length: players.count)
        
        for player in players {
            let rng = Int.random(in: 0..<indexRemapper.getRemainingLength())
            
            player.role = roleList[indexRemapper.getIndex(index: rng)]
        }
    }
    
    // Turns [Werwolf: 2, Dorfi: 3] -> [Werwolf, Werwolf, Dorfi, Dorfi, Dorfi]
    private func createRoleList() -> [WerwolfRole] {
        var roleList: [WerwolfRole] = []
        for roleEntry in roles {
            for _ in 0..<roleEntry.value {
                roleList.append(roleEntry.key)
            }
        }
        
        return roleList
    }
    
    func checkStartConditions() -> Bool {
        let roleCount = roles.map { $0.value }.reduce(0, +)
        if (roleCount != players.count) {
            errors.append(.RoleCountInvalid)
            return false
        }
        
        return true
    }
    
    public func setPlayerCount(_ count: Int) {
        while players.count < count {
            addPlayer(player: WerwolfPlayer(name: "", role: .None, index: players.count))
        }
    }
    
    private func removeLastPlayer() {
        players.removeLast()
        
        savePlayers()
    }
    
    public func addPlayer(player: WerwolfPlayer) {
        players.append(player)
        
        savePlayers()
    }
    
    public func removePlayer(_ index: Int) {
        var tempPlayers = Array(players)
        tempPlayers.removeAll(where: { $0.index == index })
        players = []
        for i in 0..<tempPlayers.count {
            let tempPlayer = tempPlayers[i]
            players.append(WerwolfPlayer(name: tempPlayer.getName(), index: players.count, imageAssets: (tempPlayer.imageAssets.0, tempPlayer.imageAssets.1, tempPlayer.imageAssets.2, tempPlayer.imageAssets.3, tempPlayer.imageAssets.4)))
        }
    }
    
    public func getPlayers() -> [WerwolfPlayer] {
        return players
    }
    
    public func setPlayerName(_ i: Int, _ n: String) {
        players[i].setName(n)
        
        
    }
    
    public func setRole(_ role: WerwolfRole, count: Int) {
        roles[role] = count
        
        saveRoles()
    }
    
    public func getRoles() -> [WerwolfRole: Int] {
        return roles
    }
    
    private func readFileOrSetDefault() {
        if !fileSaver.containsKey("\(SaveQueueKey.Werwolf_Players)") {
            setPlayerCount(3)
        } else {
            readPlayers()
        }
        
        if !fileSaver.containsKey("\(SaveQueueKey.Werwolf_Roles)") {
            setDefaultRoles()
        } else {
            readRoles()
        }
    }
    
    private func readPlayers() {
        let readString = fileSaver.read(key: "\(SaveQueueKey.Werwolf_Players)")
        
        let splitString = readString.split(separator: "#")
        for playerString in splitString {
            players.append(WerwolfPlayer.fromString(String(playerString), index: players.count))
        }
    }
    
    private func readRoles() {
        let readString = fileSaver.read(key: "\(SaveQueueKey.Werwolf_Roles)")
        
        let splitString = readString.split(separator: "#")
        for roleString in splitString {
            let splitRoleString = roleString.split(separator: ":")
            
            setRole(WerwolfRole.fromString(String(splitRoleString[0])), count: Int(splitRoleString[1])!)
        }
    }
    
    private func setDefaultRoles() {
        setRole(.Werwolf, count: 1)
        setRole(.Dorfbewohner, count: 1)
        setRole(.Hexe, count: 1)
        setRole(.Seherin, count: 1)
    }
    
    public func stop(reason: WerwolfEndCondition) {
        result = reason
        gameState = .Finished
    }
    
    public func savePlayers() {
        saveQueue.createIfAbsentQueue(
            queue: SaveQueue.Queue(
                key: .Werwolf_Players,
                delay: 1,
                valueFunc: {
                    return self.players.map {
                        $0.toString()
                    }.joined(separator: "#")
                }
            )
        )
    }
    
    public func saveRoles() {
        saveQueue.createIfAbsentQueue(
            queue: SaveQueue.Queue(
                key: .Werwolf_Roles,
                delay: 1,
                valueFunc: {
                    return self.roles.map { entry in
                        "\(entry.key):\(entry.value)"
                    }.joined(separator: "#")
                }
            )
        )
    }
}
