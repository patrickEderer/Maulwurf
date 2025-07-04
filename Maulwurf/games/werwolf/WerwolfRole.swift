//
//  WerwolfRole.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 23.06.25.
//

import Foundation

public enum WerwolfRole: CaseIterable {
    case Werwolf
    case Dorfbewohner
    case Hexe
    case Seherin
//    case Armor
//    case Jäger
    case None
    
    public static func fromString(_ string: String) -> WerwolfRole {
        for role in self.allCases {
            if "\(role)" == string {
                return role
            }
        }
        print("ROLE NOT FOUND: \(string)")
        return .None
    }
}
