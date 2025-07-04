//
//  ImpostorGameMode.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 01.06.25.
//

import Foundation

public enum ImpostorGameMode: CaseIterable {
    case Normal
    case MultipleImpostors
    case MultipleWords
    case NoImpostors
    
    public func getName() -> String {
        switch self {
        case .Normal:
            return "Normal"
        case .MultipleImpostors:
            return "Multiple Impostors"
        case .MultipleWords:
            return "Multiple Words"
        case .NoImpostors:
            return "No Impostors"
        }
    }
    
    public static func genRandom(gameModePercentages: [ImpostorGameMode: Double]) -> ImpostorGameMode {
        var rng = Double.random(in: 0..<1)
        
        if rng < gameModePercentages[.MultipleImpostors] ?? 0 {
            return .MultipleImpostors
        } else {
            rng -= gameModePercentages[.MultipleImpostors] ?? 0
        }
        
        if rng < gameModePercentages[.NoImpostors] ?? 0 {
            return .NoImpostors
        } else {
            rng -= gameModePercentages[.NoImpostors] ?? 0
        }
        
        if rng < gameModePercentages[.MultipleWords] ?? 0 {
            return .MultipleWords
        }
        
        return .Normal
    }
}
