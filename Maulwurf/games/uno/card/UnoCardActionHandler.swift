//
//  UnoCardActionHandler.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 26.07.25.
//

import Foundation

class UnoCardActionHandler {
    var engine: UnoEngine
    
    init(engine: UnoEngine) {
        self.engine = engine
    }
    
    func reset() {
        
    }
    
    func nextPlayer() {
        print("<ACTION> Next Player")
        engine.nextPlayer()
    }
    
    func reverseDirection() {
        print("<ACTION> Reverse Direction")
        if engine.direction == .Clockwise {
            engine.direction = .CounterClockwise
        } else {
            engine.direction = .Clockwise
        }
    }
    
    func drawCards(_ draw: DrawConditions) {
        print("<ACTION> DRAW")
        engine.getCurrentPlayer()
    }
}
