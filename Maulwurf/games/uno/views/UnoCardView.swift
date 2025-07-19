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
    
    var body: some View {
        ZStack {
            Image("uno.card")
                .resizable()
                .aspectRatio(1190/1729, contentMode: .fit)
                .colorMultiply(Color(hex: card.color.getHex()))
            
            Text(card.char)
                .font(.system(size: 50))
                .bold()
        }

    }
}

#Preview {
    UnoCardView(card: UnoCard(color: nil, char: nil))
}
