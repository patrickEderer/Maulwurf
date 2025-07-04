//
//  PlayerSelector.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 02.06.25.
//

import Foundation
import SwiftUI

struct PlayerSelector: View {
    var engine: ImpostorEngine
    var screen = UIScreen.main.bounds
    
    var body: some View {
        let rows = Int(floor(Double(engine.names.count + 1) / 2.0))
        ScrollView {
            VStack {
                ForEach (0..<rows, id: \.self) { row in
                    HStack {
                        ForEach (0..<2, id: \.self) { column in
                            let index = row * 2 + column
                            if engine.names.count > index {
                                let name = engine.names[index]
                                VStack {
                                    Text(name == "" ? "Player \(index + 1)" : name)
                                }.background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.gray.darker(by: 0.2))
                                        .stroke(Color.gray.darker(by: 0.4), lineWidth: 2)
                                        .frame(width: screen.width / 2 - 20, height: screen.width / 2 - 20)
                                )
                                .frame(width: screen.width / 2, height: screen.width / 2)
                                .onTapGesture {
                                    engine.showSingleCard(forIndex: index)
                                }
                            } else {
                                VStack {
                                }
                                .frame(width: screen.width / 2, height: screen.width / 2)
                            }
                        }
                    }
                }
            }
        }
    }
}
