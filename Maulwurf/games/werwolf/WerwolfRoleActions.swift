//
//  WerwolfRoleActions.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 25.06.25.
//

import Foundation

class WerwolfRoleActions {
    private static var INSTANCE: WerwolfRoleActions?
    
    private init(engine: WerwolfEngine) {
        self.engine = engine
    }
    
    public static func getInstance(engine: WerwolfEngine) -> WerwolfRoleActions {
        if (INSTANCE == nil) {
            INSTANCE = WerwolfRoleActions(engine: engine)
        }
        return INSTANCE!
    }
    
    var engine: WerwolfEngine
    
    private var killMarkedPlayerIndexes: [Int] = []
    private var healedPlayer: Int?
    
    public func werwolfAction(killedPlayerIndex: Int) {
        print("Werwolf \(killedPlayerIndex)")
        
        killMarkedPlayerIndexes.append(killedPlayerIndex)
        
        engine.roleUIScreenState = .Sleeping
    }
    
    public func resetMarkedPlayers() {
        killMarkedPlayerIndexes = []
    }
    
    public func getKillMarkedPlayers() -> [Int] {
        return killMarkedPlayerIndexes
    }
    
    public func witchHealAction(heal: Bool) {
        if heal {
            engine.witchPotions.0 = false
            healedPlayer = killMarkedPlayerIndexes.first
            killMarkedPlayerIndexes.removeFirst()
        } else {
            healedPlayer = nil
        }
    }
    
    public func witchKillAction(kill: Bool, player: Int?) {
        if kill {
            engine.witchPotions.1 = false
            killMarkedPlayerIndexes.append(player!)
        }
        
        engine.roleUIScreenState = .Sleeping
    }
    
    public func armorAction(playerIs: [Int]) {
        let players = engine.getPlayers()
        
        players[playerIs[0]].inLoveWith = playerIs[1]
        players[playerIs[1]].inLoveWith = playerIs[0]
    }
    
    public func getHealedPlayer() -> Int? {
        return healedPlayer
    }
}
