//
//  UnoCardActionHandler.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 26.07.25.
//

import Foundation

class UnoCardTwoPlayerActionHandler {
    var engine: UnoEngine
    
    init(engine: UnoEngine) {
        self.engine = engine
    }
    
    func reset() {
        
    }
    
    func otherPlayer() {
        print("<2 ACTION> Other Player")
        engine.nextPlayer()
    }
    
    func drawCards(_ draw: DrawConditions) {
        print("<2 ACTION> Draw \(draw.count) Cards")
    }
}
