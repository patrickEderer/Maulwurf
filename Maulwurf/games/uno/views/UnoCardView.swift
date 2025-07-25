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
            Image("uno.card")
                .resizable()
                .aspectRatio(1190/1729, contentMode: .fit)
                .colorMultiply(Color(hex: card.color.getHex()))
                .colorMultiply(glowing == false ? .white.darker(by: 0.5) : .white)
                .shadow(color: Color(hex: card.color.getHex()).opacity(glowing == true ? 1 : 0), radius: 10)
            
            Text(card.char)
                .font(.system(size: 50))
                .bold()
            
            VStack {
                HStack {
                    Text(card.char)
                        .font(.system(size: 20))
                        .bold()
                    
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Text(card.char)
                        .font(.system(size: 20))
                        .bold()
                }
            }
            .padding(10)
        }

    }
}

#Preview {
    UnoCardView(card: UnoCard.genRandom(), glowing: false)
}
