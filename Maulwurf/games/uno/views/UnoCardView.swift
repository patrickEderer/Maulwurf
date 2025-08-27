//
//  UnoCardView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 14.07.25.
//

import Foundation
import SwiftUI

struct UnoCardView: View, Identifiable {
    var id: UUID? = nil
    
    @ObservedObject var tiltSensor = TiltSensor.getInstance()
    var unoColorManager = UnoColorManager.getInstance()
    
    var card: any UnoCard
    var glowing: Bool? = nil
    @State private var measuredSize: CGSize?
    
    init(card: any UnoCard, glowing: Bool? = nil) {
        self.card = card
        self.glowing = glowing
        self.id = card.id
    }
    
    var body: some View {
        
        ZStack {
            Image("uno.card.color")
                .resizable()
                .interpolation(.none)
                .aspectRatio(1190/1729, contentMode: .fit)
                .colorMultiply(Color(hex: unoColorManager.getHexCode(colorIndex: card.getColorIndex())))
                .colorMultiply(glowing == false ? .white.darker(by: 0.5) : .white)
                .shadow(color: Color(hex: unoColorManager.getHexCode(colorIndex: card.getColorIndex())).opacity(glowing == true ? 1 : 0), radius: 10)
            
            let imageName = card.getImageName()
            if imageName != "" {
                Image(imageName)
                    .resizable()
                    .interpolation(.none)
                    .aspectRatio(1190/1729, contentMode: .fit)
                    .colorMultiply(glowing == false ? .white.darker(by: 0.5) : .white)
                    .background(
                        GeometryReader { geo in
                            Color.clear
                                .onAppear { measuredSize = geo.size }
                                .onChange(of: geo.size) { old, new in measuredSize = new }
                        }
                    )
                    .offset(
                        x: tiltSensor.getTilt().x * (measuredSize?.width ?? 1) * 0.015,
                        y: tiltSensor.getTilt().y * -(measuredSize?.height ?? 1) * 0.015
                    )
                    .mask(RoundedRectangle(cornerRadius: measuredSize?.width.scaled(by: 1.0 / 4.0) ?? 0))
            }
            
            Image("uno.card.border")
                .resizable()
                .interpolation(.none)
                .aspectRatio(1190/1729, contentMode: .fit)
                .colorMultiply(glowing == false ? .white.darker(by: 0.5) : .white)
        }
    }
}

#Preview {
    UnoCardView(card: UnoCardBackside(), glowing: true)
}
