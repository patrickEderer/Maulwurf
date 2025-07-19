//
//  WerwolfPlayer.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 23.06.25.
//

import Foundation
import SwiftUI

public class WerwolfPlayer {
    private var name: String
    var role: WerwolfRole
    var index: Int
    var inLoveWith: Int? = nil
    
    var isAlive: Bool = true
    
    // Skin color, hair, hair color, eyes, mouth
    var imageAssets: (Color, Int, Color, Int, Int)
    
    init(name: String, role: WerwolfRole, index: Int) {
        self.name = name
        self.role = role
        self.index = index
        
        imageAssets = (
            // Skin color
            Color(hex: "#F6CEA9"),
            
            // Hair
            Int.random(in: 0..<6),
            
            // Hair color
            Color.brown,
            
            // Eyes
            Int.random(in: 0..<9),
            
            // Mouth
            Int.random(in: 0..<12)
        )
    }
    
    init(name: String, index: Int, imageAssets: (Color, Int, Color, Int, Int)) {
        self.name = name
        self.role = .None
        self.index = index
        
        self.imageAssets = imageAssets
    }
    
    public func reset() {
        role = .None
        inLoveWith = nil
        isAlive = true
    }
    
    public func setRandomAssets() {
        imageAssets = (
            // Skin color
            Color(hex: "#F6CEA9"),
            
            // Hair
            Int.random(in: 0...6),
            
            // Hair color
            Color.brown,
            
            // Eyes
            Int.random(in: 0...8),
            
            // Mouth
            Int.random(in: 0...11)
        )
    }
    
    public func getBackendName() -> String? {
        return name != "" ? name : nil
    }
    
    public func getName() -> String {
        if name != "" {
            return name
        } else {
            return "Player \(index + 1)"
        }
    }
    
    public func setName(_ name: String) {
        self.name = name
    }
    
    public func toString() -> String {
        let str = "\(getBackendName() ?? "*"):\(imageAssets.0.toHex() ?? "000000")&\(imageAssets.1)&\(imageAssets.2.toHex() ?? "000000")&\(imageAssets.3)&\(imageAssets.4)"
        return str
    }
    
    public static func fromString(_ string: String, index: Int) -> WerwolfPlayer {
        let splitStr = string.split(separator: ":")
        let imageAssetsSplit = splitStr[1].split(separator: "&")
        
        var name = String(splitStr[0])
        
        if name == "*" { name = "Player \(index + 1)" }
        
        return WerwolfPlayer(
            name: name,
            index: index,
            imageAssets: (
                Color(hex: "#\(imageAssetsSplit[0])"),
                Int(imageAssetsSplit[1])!,
                Color(hex: "#\(imageAssetsSplit[2])"),
                Int(imageAssetsSplit[3])!,
                Int(imageAssetsSplit[4])!
            )
        )
    }
}
