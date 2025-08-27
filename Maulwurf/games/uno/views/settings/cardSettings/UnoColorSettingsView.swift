//
//  UnoColorSettingsView.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 20.08.25.
//

import Foundation
import SwiftUI

struct UnoColorSettingsView: View {
    @ObservedObject var updater = Updater.getInstance()
    @ObservedObject var unoColorManager = UnoColorManager.getInstance()
    var cardSettings: UnoCardSettingsView
    
    var body: some View {
        VStack {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(0..<unoColorManager.getColorCount(), id: \.self) { i in
                    let color = unoColorManager.getHexCode(colorIndex: i)
                    ZStack {
                        ColorPicker("", selection: Binding(get: {
                            Color(hex: color)
                        }, set: { new in
                            unoColorManager.setHexCode(colorIndex: i, hexCode: new.toHex()!)
                        }))
                        .background(
                            UnoCardView(card: UnoNumberCard(colorIndex: i, number: 3))
                                .scaleEffect(3)
                        )
                        .contextMenu {
                            Button("Delete") {
                                unoColorManager.removeColor(i)
                            }
                        }
                    }
                }
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "#CCCCCC"))
                    .stroke(Color(hex: "#AAAAAA"))
                    .frame(width: 50, height: 50)
                    .overlay(Text("+").font(.title))
                    .onTapGesture {
                        unoColorManager.addColor()
                    }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 40)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color(hex: "#444444"))
        )
    }
}
