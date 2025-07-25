//
//  UnoCardColor.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 14.07.25.
//

import Foundation

enum UnoCardColor: CaseIterable {
    case RED
    case GREEN
    case YELLOW
    case BLUE
    case WILD
    case PURPLE
    case GOLD
    
    public func getHex() -> String {
        switch self {
        case .RED: return "#FF0000"
        case .GREEN: return "#00FF3B"
        case .YELLOW: return "#FFF900"
        case .BLUE: return "#00D9FF"
        case .WILD: return "#BBBBBB"
        case .PURPLE: return "#872B8D"
        case .GOLD: return "#E7B700"
        }
    }
}
