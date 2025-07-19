//
//  WerwolfRole.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 23.06.25.
//

import Foundation
import SwiftUICore

public enum WerwolfRole: CaseIterable {
    case Werwolf
    case Dorfbewohner
    case Hexe
    case Seherin
    case Armor
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
    
    public func getColor() -> Color {
        switch self {
        case .Werwolf: Color(hex: "#2E0209")
        case .Dorfbewohner: Color(hex: "#002E01")
        case .Hexe: Color(hex: "#35003C")
        case .Seherin: Color(hex: "#2C0046")
        case .Armor: Color(hex: "#5B193C")
        default: Color(hex: "#000000")
        }
    }
    
    public func getForegroundColor() -> Color {
        switch self {
        case .Werwolf: Color(hex: "#FFBEC0")
        case .Dorfbewohner: Color(hex: "#CDFFCB")
        case .Hexe: Color(hex: "#F5B2F8")
        case .Seherin: Color(hex: "#EEAFFF")
        case .Armor: Color(hex: "#FF8CE9")
        default: Color(hex: "#FBFF55")
        }
    }
}
