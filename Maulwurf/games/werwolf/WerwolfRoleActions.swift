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
        print("witch heal \(heal)")
        
        if heal {
            killMarkedPlayerIndexes.removeFirst()
        }
    }
    
    public func witchKillAction(kill: Bool, player: Int?) {
        print("Withc kill \(kill) \(player ?? -1)")
        if kill {
            killMarkedPlayerIndexes.append(player!)
        }
        
        engine.roleUIScreenState = .Sleeping
    }
}
