//
//  UnoPlayer.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 22.07.25.
//

import Foundation

public class UnoPlayer {
    var name: String
    var cards: [UnoCard] = []
    
    init(name: String) {
        self.name = name
        cards = (0..<20).map { _ in
            UnoCard.genRandom()
        }
        
        
    }
}
