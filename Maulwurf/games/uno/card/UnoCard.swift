//
//  UnoCard.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 14.07.25.
//

import Foundation

class UnoCard: Hashable {
    var color: UnoCardColor
    var char: String
    
    init(color: UnoCardColor?, char: String?) {
        self.color = color ?? UnoCardColor.allCases[Int.random(in: 0..<UnoCardColor.allCases.count)]
        self.char = char ?? ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "+2"][Int.random(in: 0..<11)]
    }
    
    private var id = UUID()
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: UnoCard, rhs: UnoCard) -> Bool {
        return lhs.id == rhs.id
    }
}
