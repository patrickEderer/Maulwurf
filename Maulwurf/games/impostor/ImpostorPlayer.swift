//
//  ImpostorPlayer.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 01.06.25.
//

import Foundation

public class ImpostorPlayer {
    var isImpostor: Bool
    var word: String
    var name: String
    
    var imageAssets: (Int, Int, Int)
    
    init(name: String = "guest", isImpostor: Bool, word: String) {
        self.name = name
        self.isImpostor = isImpostor
        self.word = word
        
        imageAssets = (
            // Head
            Int.random(in: 0..<10),
            
            // Eyes
            Int.random(in: 0..<9),
            
            // Mouth
            Int.random(in: 0..<12)
        )
    }
}
