//
//  DrawConditions.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 26.07.25.
//

import Foundation

class DrawConditions {
    var count: Int
    var canPlace2OnTop: Bool
    var canPlace4OnTop: Bool
    
    init(
        count: Int, canPlace2OnTop: Bool = false, canPlace4OnTop: Bool = false
    ) {
        self.count = count
        self.canPlace2OnTop = canPlace2OnTop
        self.canPlace4OnTop = canPlace4OnTop
    }
}
