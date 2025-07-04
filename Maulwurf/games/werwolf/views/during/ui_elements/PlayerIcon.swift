//
//  PlayerIcon.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 25.06.25.
//

import Foundation
import SwiftUI

struct PlayerIcon: View {
    var player: WerwolfPlayer
    var size: Double
    
    
    var body: some View {
        // Skin color, hair, hair color, eyes, mouth
        ZStack {
            //Head
            Image("head")
                .resizable()
                .interpolation(.none)
                .frame(width: size * 1.05, height: size * 1.05 * 1.5)
                .colorMultiply(player.imageAssets.0)
            
            //Hair
            Image("hair.\(player.imageAssets.1)")
                .resizable()
                .interpolation(.none)
                .frame(width: size * 1.05, height: size * 1.05 * 1.5)
                .colorMultiply(player.imageAssets.2)
            
            //Eyes
            Image("eyes.\(player.imageAssets.3)")
                .resizable()
                .interpolation(.none)
                .frame(width: size, height: size)
                .offset(x: 0, y: size * 0.15)
            
            //Mouth
            Image("mouth.\(player.imageAssets.4)")
                .resizable()
                .interpolation(.none)
                .frame(width: size, height: size)
                .offset(x: 0, y: size * 0.15)
        }.clipShape(Rectangle())
    }
}
