//
//  PlayerGrid.swift
//  Maulwurf
//
//  Created by Ederer Patrick on 25.06.25.
//

import Foundation
import SwiftUI

struct PlayerGrid: View {
    var players: [WerwolfPlayer]
    var bounds: CGRect
    var onClick: ([Int]) -> Void
    var selectionStyle: SelectionStyle = .Single
    
    //Fill (selected), Stroke, Stroke (selected)
    var colors: (Color, Color, Color)
    
    @State private var selected: [Int] = []
    
    init(
        players: [WerwolfPlayer],
        bounds: CGRect = UIScreen.main.bounds,
        onClick: @escaping ([Int]) -> Void = { _ in },
        colors: (Color, Color, Color) = (Color(hex: "#EA4D3D").opacity(1 / 3), Color(hex: "#EA4D3D"), Color(hex: "#FF0000"))
    ) {
        self.players = players
        self.bounds = bounds
        self.onClick = onClick
        self.colors = colors
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: (0..<2).map { _ in GridItem(.fixed(bounds.width * 0.45)) }) {
                ForEach (0..<players.count, id: \.self) { i in
                    ZStack {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(getFillColor(i))
                            .stroke(getStrokeColor(i), lineWidth: 2)
                            .contentShape(Rectangle())
                            .frame(width: bounds.width * 0.45, height: bounds.width * 0.45)
                            .onTapGesture {
                                clickedOn(i)
                                
                                onClick(selected)
                            }
                            .overlay {
                                ZStack {
                                    ZStack {
                                        let player = players[i]
                                        
                                        PlayerIcon(player: player, size: bounds.width * 0.3)
                                        
                                        VStack {
                                            Text("\(players[i].getName())")
                                                .fontWeight(.bold)
                                                .minimumScaleFactor(0.3)
                                                .padding(.top, 5)
                                            Spacer()
                                        }
                                    }
                                    HStack {
                                        Spacer()
                                        VStack {
                                            Spacer()
                                            ZStack {
                                                if !players[i].isAlive {
                                                    Image(systemName: "bolt.fill")
                                                }
                                                if players[i].isAwake {
                                                    Image(systemName: "eye.fill")
                                                }
                                            }.padding(5)
                                        }
                                    }
                                }.allowsHitTesting(false)
                            }
                    }
                }
            }.padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 5))
        }
        .frame(width: bounds.width, height: bounds.height)
    }
    
    private func getFillColor(_ i: Int) -> Color {
        if !players[i].isAlive {
            return .gray.opacity(0.1)
        }
        
        if players[i].isAwake {
            return .clear
        }
        
        return selected.contains(i) ? colors.0 : .clear
    }
    
    private func getStrokeColor(_ i: Int) -> Color {
        if !players[i].isAlive {
            return colors.1.darker(by: 0.75)
        }
        
        if players[i].isAwake {
            return colors.1.darker(by: 0.5)
        }
        
        return selected.contains(i) ? colors.2 : colors.1
    }
    
    private func clickedOn(_ i: Int) {
        if !players[i].isAlive {
            return
        }
        
        if players[i].isAwake {
            return
        }
        
        SensoryFeedback.getInstance().impact(.light)
        
        if selectionStyle == .Single {
            if selected.contains(i) {
                selected.removeAll { $0 == i }
            } else {
                selected = [i]
            }
        } else if selectionStyle == .Pair {
            if selected.contains(i) {
                selected.removeAll { $0 == i }
            } else {
                if selected.count >= 1 {
                    selected.removeFirst(selected.count - 1)
                }
                selected.append(i)
            }
        } else {
            if selected.contains(i) {
                selected.removeAll { $0 == i }
            } else {
                selected.append(i)
            }
        }
    }
    
    private func copy() -> PlayerGrid {
        return PlayerGrid(players: players, bounds: bounds, onClick: onClick, colors: colors)
    }
    
    public func setBounds(bounds: CGRect) -> PlayerGrid {
        var copy = copy()
        copy.bounds = bounds
        return copy
    }
    
    public func onClick(onClick: @escaping ([Int]) -> Void) -> PlayerGrid {
        var copy = copy()
        copy.onClick = onClick
        return copy
    }
    
    public func setColors(colors: (Color, Color, Color)) -> PlayerGrid {
        var copy = copy()
        copy.colors = colors
        return copy
    }
}
