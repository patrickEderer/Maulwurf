//
//  UnoCardView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 14.07.25.
//

import Foundation
import SwiftUI

struct UnoCardView: View {
    var card: UnoCard
    var glowing: Bool? = nil
    
    var body: some View {
        ZStack {
            Image("uno.card.color")
                .resizable()
                .interpolation(.none)
                .aspectRatio(1190/1729, contentMode: .fit)
                .colorMultiply(Color(hex: card.color.getHex()))
                .colorMultiply(glowing == false ? .white.darker(by: 0.5) : .white)
            
            Image("uno.card.border")
                .resizable()
                .interpolation(.none)
                .aspectRatio(1190/1729, contentMode: .fit)
                .colorMultiply(glowing == false ? .white.darker(by: 0.5) : .white)
            
            
            Image("uno.card.number.\(card.char)")
                .resizable()
                .interpolation(.none)
                .aspectRatio(1190/1729, contentMode: .fit)
                .colorMultiply(glowing == false ? .white.darker(by: 0.5) : .white)
        }
        .shadow(color: Color(hex: card.color.getHex()).opacity(glowing == true ? 1 : 0), radius: 10)

    }
}

#Preview {
    UnoCardView(card: UnoCard.genRandom(), glowing: nil)
}
