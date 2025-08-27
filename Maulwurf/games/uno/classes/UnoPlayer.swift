//
//  UnoPlayer.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 22.07.25.
//

import Foundation
import SwiftUI

public class UnoPlayer: PlayerWithIcon {
    var name: String
    var cards: [any UnoCard] = []
    var imageAssets: (Color, Int, Color, Int, Int)
    var drawQueue: [(any UnoCard, UnoDrawReason)] = []
    var autoSort: Bool = false
    var isPlaying = true
    
    func getImageAssets() -> (Color, Int, Color, Int, Int) {
        return imageAssets
    }
    
    init(name: String) {
        self.name = name
        
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
    
    init(name: String, imageAssets: (Color, Int, Color, Int, Int), isPlaying: Bool = true) {
        self.name = name
        self.imageAssets = imageAssets
        self.isPlaying = isPlaying
    }
    
    func setRandomAssets() {
        imageAssets = (
            // Skin color
            imageAssets.0,
            
            // Hair
            Int.random(in: 0..<6),
            
            // Hair color
            imageAssets.2,
            
            // Eyes
            Int.random(in: 0..<9),
            
            // Mouth
            Int.random(in: 0..<12)
        )
    }
    
    public func toString() -> String {
        let str = "\(name):\(imageAssets.0.toHex() ?? "000000")&\(imageAssets.1)&\(imageAssets.2.toHex() ?? "000000")&\(imageAssets.3)&\(imageAssets.4):\(isPlaying)"
        return str
    }
    
    public static func fromString(_ string: String, index: Int) -> UnoPlayer {
        let splitStr = string.split(separator: ":")
        let imageAssetsSplit = splitStr[1].split(separator: "&")
        
        let name = String(splitStr[0])
        var isPlaying: Bool = true
        if splitStr.count > 2 {
            isPlaying = (String(splitStr[2]) == "true")
        }
        
        if imageAssetsSplit.count < 5 {
            return UnoPlayer(name: name)
        }
        
        return UnoPlayer(
            name: name,
            imageAssets: (
                Color(hex: "#\(imageAssetsSplit[0])"),
                Int(imageAssetsSplit[1]) ?? 0,
                Color(hex: "#\(imageAssetsSplit[2])"),
                Int(imageAssetsSplit[3]) ?? 0,
                Int(imageAssetsSplit[4]) ?? 0
            ),
            isPlaying: isPlaying
        )
    }
}
