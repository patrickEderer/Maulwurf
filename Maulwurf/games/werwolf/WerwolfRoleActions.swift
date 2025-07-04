//
//  WerwolfRoleActions.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 25.06.25.
//

import Foundation

class WerwolfRoleActions {
    var engine: WerwolfEngine
    
    private var killMarkedPlayerIndexes: [Int] = []
    
    init(engine: WerwolfEngine) {
        self.engine = engine
    }
    
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
            killMarkedPlayerIndexes.removeFirst()
        }
    }
    
    public func witchKillAction(kill: Bool, player: Int?) {
        if kill {
            engine.witchPotions.1 = false
            killMarkedPlayerIndexes.append(player!)
        }
        
        engine.roleUIScreenState = .Sleeping
    }
    
    public func armorAction() {
        
    }
}
